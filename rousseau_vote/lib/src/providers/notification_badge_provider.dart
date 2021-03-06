import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:rousseau_vote/src/injection/injector_config.dart';
import 'package:rousseau_vote/src/models/poll.dart';
import 'package:rousseau_vote/src/models/poll_list.dart';
import 'package:rousseau_vote/src/models/user/current_user.dart';
import 'package:rousseau_vote/src/network/handlers/poll_network_handler.dart';
import 'package:rousseau_vote/src/network/handlers/user_network_handler.dart';
import 'package:rousseau_vote/src/screens/main/main_page.dart';

@lazySingleton
class NotificationBadgeProvider extends ChangeNotifier {
  NotificationBadgeProvider() {
    fetchCurrentUser();
    fetchPolls();
  }

  CurrentUser _currentUser;
  List<Poll> _polls;

  bool shouldShowBadge(MainPageType mainPageType) {
    switch (mainPageType) {
      case MainPageType.POLLS:
        return _canVoteNow();
      case MainPageType.PROFILE:
        return !_hasProfile();
    }
    return false;
  }

  bool shouldShowDrawerBadge() {
    if (_currentUser == null) {
      return false;
    }
    return _currentUser.shouldVerifyIdentity;
  }

  void fetchCurrentUser() {
    final UserNetworkHandler userNetworkHandler = getIt<UserNetworkHandler>();
    userNetworkHandler
        .fetchCurrentUser(fetchPolicy: FetchPolicy.cacheFirst)
        .then((CurrentUser currentUser) {
      _currentUser = currentUser;
      notifyListeners();
    }).catchError((Object ignore) {});
  }

  void fetchPolls() {
    final PollNetworkHandler pollNetworkHandler = getIt<PollNetworkHandler>();
    pollNetworkHandler
        .fetchPolls(fetchPolicy: FetchPolicy.cacheFirst)
        .then((PollList pollList) {
      _polls = pollList.polls;
      notifyListeners();
    }).catchError((Object ignore) {});
  }

  void onCurrentUserUpdated() {
    fetchCurrentUser();
  }

  void onPollsUpdate() {
    fetchPolls();
  }

  bool _hasProfile() {
    if (_currentUser == null) {
      return false;
    }
    return _currentUser.hasCompiledProfile;
  }

  bool _canVoteNow() {
    if (_polls == null) {
      return false;
    }
    for (Poll poll in _polls) {
      if (poll.open && poll.canVote) {
        return true;
      }
    }
    return false;
  }
}
