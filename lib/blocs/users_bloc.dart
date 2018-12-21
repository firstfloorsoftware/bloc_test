import 'dart:async';
import 'dart:math';
import 'package:bloc_test/blocs/bloc_provider.dart';
import 'package:bloc_test/blocs/user_bloc.dart';
import 'package:bloc_test/models/user.dart';
import 'package:bloc_test/models/user_stats.dart';

class UsersBloc implements BlocBase {
  final List<User> _users = List<User>();
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
      _users.add(User(id: i.toString(), name: 'User $i'));
    }
    // notify listeners
    _usersController.sink.add(_users);

    // start a timer to emulate online/offline behavior
    _onlineTimer = Timer.periodic(Duration(seconds: 1), onTick);
  }

  Stream<UserStats> get userStatsStream => _userStatsController.stream;
  Stream<List<User>> get usersStream => _usersController.stream;

  void onTick(Timer timer) {
    final rnd = Random();
    // toggle online/offline state of random 5% of the users every second
    for (var i = 0; i < _users.length * .05; i++) {
      var user = _users[rnd.nextInt(_users.length)];
      user.online = !user.online;

      _onlineUserController.sink.add(user);
    }
    // update user stats
    _userStatsController.sink.add(UserStats(
        count: _users.length,
        online: _users.where((user) => user.online).length));
  }

  void search(String searchTerm) {
    if (searchTerm == null || searchTerm.isEmpty) {
      _usersController.sink.add(_users);
    } else {
      _usersController.sink.add(_users
          .where((u) => u.name.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList());
    }
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
