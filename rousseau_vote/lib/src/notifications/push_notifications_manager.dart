import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

@singleton
class PushNotificationManager {

  PushNotificationManager(this._firebaseMessaging);

  final FirebaseMessaging _firebaseMessaging;
  String _currentToken;

  Future<void> onLogin(String userId) async {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.setAutoInitEnabled(false);
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
      },
    );
    _registerToken(userId);
  }

  void onLogout() {
    _currentToken = null;
    _firebaseMessaging.deleteInstanceID();
    // TODO Unregister token
  }

  Future<void> _registerToken(String userId) async {
    _currentToken = await _firebaseMessaging.getToken();

    // Save it to Firestore
    if (_currentToken != null) {
      print('Registering: $userId');
//      final DocumentReference tokens = Firestore.instance
//          .collection('users')
//          .document(userId)
//          .collection('tokens')
//          .document(_currentToken);
//
//      await tokens.setData(<String, dynamic>{
//        'token': _currentToken,
//        'createdAt': FieldValue.serverTimestamp(),
//        'platform': Platform.operatingSystem
//      });
    }
  }
}
