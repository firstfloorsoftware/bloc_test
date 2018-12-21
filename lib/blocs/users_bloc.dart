import 'dart:async';
import 'dart:math';
import 'package:bloc_test/blocs/bloc_provider.dart';
import 'package:bloc_test/blocs/user_bloc.dart';
import 'package:bloc_test/models/user.dart';
import 'package:bloc_test/models/user_stats.dart';

class UsersBloc implements BlocBase {
  final List<User> _allUsers = List<User>();
  final List<User> _visibleUsers = List<User>();
  Timer _onlineTimer;

  final StreamController<List<User>> _usersController =
      StreamController<List<User>>();
  final StreamController<User> _onlineUserController =
      StreamController<User>.broadcast();
  final StreamController<UserStats> _userStatsController =
      StreamController<UserStats>();

  UsersBloc() {
    // create users
    for (var i = 0; i < 100; i++) {
      _allUsers.add(User(id: i.toString(), name: 'User $i'));
    }
    // initialize visible users
    search(null);

    // start a timer to emulate online/offline behavior
    _onlineTimer = Timer.periodic(Duration(seconds: 1), onTick);
  }

  Stream<UserStats> get userStatsStream => _userStatsController.stream;
  Stream<List<User>> get usersStream => _usersController.stream;

  void onTick(Timer timer) {
    final rnd = Random();
    // toggle online/offline state of random 5% of the users every second
    for (var i = 0; i < _allUsers.length * .05; i++) {
      var user = _allUsers[rnd.nextInt(_allUsers.length)];
      user.online = !user.online;

      _onlineUserController.sink.add(user);
    }

    updateVisibleUserStats();
  }

  void updateVisibleUserStats() {
    _userStatsController.sink.add(UserStats(
        count: _visibleUsers.length,
        online: _visibleUsers.where((user) => user.online).length));
  }

  void search(String searchTerm) {
    _visibleUsers.clear();
    if (searchTerm == null || searchTerm.isEmpty) {
      _visibleUsers.addAll(_allUsers);
    } else {
      _visibleUsers.addAll(_allUsers.where(
          (u) => u.name.toLowerCase().contains(searchTerm.toLowerCase())));
    }

    _usersController.sink.add(_visibleUsers);
    updateVisibleUserStats();
  }

  UserBloc createBloc(User user) {
    return UserBloc(user,
        _onlineUserController.stream.where((u) => user == u).listen(null));
  }

  void dispose() {
    _onlineTimer.cancel();
    _usersController.close();
    _onlineUserController.close();
    _userStatsController.close();
  }
}
