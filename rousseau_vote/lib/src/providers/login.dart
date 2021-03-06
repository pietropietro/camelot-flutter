import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:rousseau_vote/src/injection/injector_config.dart';
import 'package:rousseau_vote/src/models/token.dart';
import 'package:rousseau_vote/src/network/exceptions/too_many_attempts_exception.dart';
import 'package:rousseau_vote/src/network/exceptions/wrong_credentials_exception.dart';
import 'package:rousseau_vote/src/network/graphql/graphql_queries.dart';
import 'package:rousseau_vote/src/network/handlers/login_network_handler.dart';
import 'package:rousseau_vote/src/network/response/token_response.dart';
import 'package:rousseau_vote/src/network/result/credentials_login_result.dart';
import 'package:rousseau_vote/src/notifications/push_notifications_manager.dart';
import 'package:rousseau_vote/src/prefetch/prefetch_manager.dart';
import 'package:rousseau_vote/src/store/token_store.dart';

@singleton
class Login with ChangeNotifier {
  Login(this._loginNetworkHandler, this._tokenStore, this._pushNotificationManager);

  final LoginNetworkHandler _loginNetworkHandler;
  final TokenStore _tokenStore;
  final PushNotificationManager _pushNotificationManager;
  LoginState _loginState;
  ErrorState _errorState;

  void _loadInitialState() {
    final LoginState loginState = _tokenStore.hasValidToken()
        ? LoginState.LOGGED_IN
        : LoginState.LOGGED_OUT;
    _moveToState(loginState: loginState, errorState: ErrorState.NO_ERRORS, shouldNotifyListeners: false);
  }

  void _moveToState(
      {LoginState loginState,
      ErrorState errorState,
      bool shouldNotifyListeners = true}) {
    if (loginState != null) {
      _loginState = loginState;
    }
    if (errorState != null) {
      _errorState = errorState;
    }
    if (shouldNotifyListeners) {
      notifyListeners();
    }
  }

  Future<bool> credentialsLogin(String email, String password) async {
    _moveToState(loginState: LoginState.CREDENTIALS_LOADING);

    try {
      final CredentialsLoginResult result =
          await _loginNetworkHandler.credentialsLogin(email, password);
      if (result.loginSession != null) {
        _moveToState(loginState: LoginState.CREDENTIALS_AUTHENTICATED);
      } else if (result.tokenResponse != null) {
        _onTokenResponse(result.tokenResponse);
      } else {
        _moveToState(
            loginState: LoginState.LOGGED_OUT,
            errorState: ErrorState.NETWORK_ERROR);
      }
    } on WrongCredentialsException {
      _moveToState(
          loginState: LoginState.LOGGED_OUT,
          errorState: ErrorState.CREDENTIALS_ERROR);
    } on DioError catch (e) {
      _moveToState(
          loginState: LoginState.LOGGED_OUT,
          errorState: ErrorState.NETWORK_ERROR);
    }
    return isCredentialsAuthenticated();
  }

  Future<bool> submitCode(String code) async {
    _moveToState(loginState: LoginState.CODE_LOADING);
    try {
      final TokenResponse tokenResponse =
          await _loginNetworkHandler.submitTwoFactorCode(code);
      return _onTokenResponse(tokenResponse);
    } on WrongCredentialsException {
      _moveToState(
          loginState: LoginState.CREDENTIALS_AUTHENTICATED,
          errorState: ErrorState.CREDENTIALS_ERROR);
      return false;
    } on TooManyAttemptsException {
      _moveToState(
          loginState: LoginState.CREDENTIALS_AUTHENTICATED,
          errorState: ErrorState.TOO_MANY_ATTEMPTS);
      return false;
    } on DioError {
      _moveToState(
          loginState: LoginState.CREDENTIALS_AUTHENTICATED,
          errorState: ErrorState.NETWORK_ERROR);
      return false;
    }
  }

  bool _onTokenResponse(TokenResponse tokenResponse) {
    if (tokenResponse.hasErrors()) {
      return false;
    }

    final Token token = Token.fromTokenResponse(tokenResponse);
    _tokenStore.onTokenFetched(token);
    if (_tokenStore.hasValidToken()) {
      _onLogin(token);
      _moveToState(
          loginState: LoginState.LOGGED_IN, errorState: ErrorState.NO_ERRORS);
      return true;
    } else {
      _moveToState(
          loginState: LoginState.CREDENTIALS_AUTHENTICATED,
          errorState: ErrorState.INVALID_TOKEN);
      return false;
    }
  }

  Future<bool> resendCode() async {
    _moveToState(loginState: LoginState.CODE_RESEND_LOADING);
    try {
      return await _loginNetworkHandler.sendNewCode();
    } catch (_) {
      return false;
    } finally {
      _moveToState(loginState: LoginState.CREDENTIALS_AUTHENTICATED);
    }
  }

  Future<bool> voiceCall() async {
    _moveToState(loginState: LoginState.CODE_VOICE_CALL_LOADING);
    try {
      return await _loginNetworkHandler.voiceCall();
    } catch (_) {
      return false;
    } finally {
      _moveToState(loginState: LoginState.CREDENTIALS_AUTHENTICATED);
    }
  }

  void cancelCode() {
    _moveToState(loginState: LoginState.LOGGED_OUT);
  }

  void sessionExpired() {
    _moveToState(loginState: LoginState.LOGGED_OUT);
  }

  void unableToRefreshToken() {
    _moveToState(loginState: LoginState.LOGGED_OUT);
  }

  void logout() {
    _onLogout();
    // TODO invalidate session here
    _moveToState(loginState: LoginState.LOGGED_OUT);
  }

  void _onLogout() {
    _pushNotificationManager.onLogout().whenComplete(() {
      _tokenStore.deleteToken();
    });
  }

  void _onLogin(Token token) {
    final String userId = _tokenStore.getUserId();
    if (userId != null) {
      _pushNotificationManager.onLogin(userId);
      getIt<PrefetchManager>().prefetch(currentUserShort);
    }
  }

  bool isWaitingForVoiceCall() =>
      _loginState == LoginState.CODE_VOICE_CALL_LOADING;

  bool isWaitingResendCode() => _loginState == LoginState.CODE_RESEND_LOADING;

  bool isLoggedIn() {
    if(_loginState == null) {
      _loadInitialState();
    }
    return _loginState == LoginState.LOGGED_IN;
  }

  bool isLoading() => _loginState == LoginState.CREDENTIALS_LOADING;

  bool isLoadingCode() => _loginState == LoginState.CODE_LOADING;

  bool isLastLoginFailed() => _errorState == ErrorState.CREDENTIALS_ERROR;

  bool isLastTokenInvalid() => _errorState == ErrorState.INVALID_TOKEN;

  bool isLastCodeSubmissionFailed() =>
      _errorState == ErrorState.CREDENTIALS_ERROR;

  bool hasTooManyAttempts() => _errorState == ErrorState.TOO_MANY_ATTEMPTS;

  bool hasGenericError() => _errorState == ErrorState.GENERIC_ERROR;

  bool isCredentialsAuthenticated() =>
      _loginState != null &&
      _loginState != LoginState.LOGGED_OUT &&
      _loginState != LoginState.CREDENTIALS_LOADING;

  bool hasNetworkError() => _errorState == ErrorState.NETWORK_ERROR;

  bool hasError() => _errorState != ErrorState.NO_ERRORS;

  ErrorState get errorState => _errorState;

  void resetErrors({bool shouldNotifyListeners = false}) => _moveToState(
      errorState: ErrorState.NO_ERRORS,
      shouldNotifyListeners: shouldNotifyListeners);
}

enum ErrorState {
  NO_ERRORS,
  CREDENTIALS_ERROR,
  TOO_MANY_ATTEMPTS,
  GENERIC_ERROR,
  NETWORK_ERROR,
  INVALID_TOKEN
}

enum LoginState {
  LOGGED_OUT,
  CREDENTIALS_LOADING,
  CREDENTIALS_AUTHENTICATED,
  CODE_LOADING,
  CODE_RESEND_LOADING,
  CODE_VOICE_CALL_LOADING,
  LOGGED_IN
}
