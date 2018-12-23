import 'dart:async';
import 'dart:math';
import 'package:bloc_test/blocs/bloc_provider.dart';
import 'package:bloc_test/models/user.dart';
import 'package:bloc_test/models/user_stats.dart';

class UsersBloc implements BlocBase {
  final Map<String, User> _users = Map<String, User>();
  int _userIdSeed = 0;
  String _searchTerm;
  Timer _onlineTimer;

  // signal user list changes
  final StreamController<List<User>> _usersController =
      StreamController<List<User>>();
  // signal user changes
  final StreamController<User> _userController =
      StreamController<User>.broadcast();
  // signal user statistics
  final StreamController<UserStats> _userStatsController =
      StreamController<UserStats>();

  UsersBloc() {
    // create users
    for (var i = 0; i < 100; i++) {
      final id = i.toString();
      _users[id] = User(id: id, name: 'User $id');
    }
    _userIdSeed = _users.length;

    // initialize users stream
    search(null);

    // start a timer to emulate online/offline behavior
    _onlineTimer = Timer.periodic(Duration(seconds: 1), _onTick);
  }

  Stream<List<User>> get usersStream => _usersController.stream;
  Stream<User> get userStream => _userController.stream;
  Stream<UserStats> get userStatsStream => _userStatsController.stream;

  void _onTick(Timer timer) {
    // toggle online/offline state of 10 random users
    final keys = _users.keys.toList();
    final rnd = Random();

    for (var i = 0; i < 10; i++) {
      // get random id
      final id = keys[rnd.nextInt(_users.length)];

      // update online state
      _updateUser(id, (user) => user.copyWith(online: !user.online), updateStats: false);
    }

    // update stats once, and not for every user update
    _updateUserStats();
  }

  void _updateUser(String id, User Function(User) update,
      {bool updateStats = true}) {
    // update user in map (id must exist)
    final user = _users.update(id, update);

    // signal update
    _userController.sink.add(user);

    if (updateStats) {
      // update stats
      _updateUserStats();
    }
  }

  void _updateUsers() {
    // filter users based on search term
    final users = _users.values
        .where((user) =>
            _searchTerm == null ||
            _searchTerm.isEmpty ||
            user.name.toLowerCase().contains(_searchTerm.toLowerCase()))
        .toList();

    // sort (don't do this for large lists)
    users.sort();

    // signal listeners
    _usersController.sink.add(users);

    // update stats
    _updateUserStats();
  }

  void _updateUserStats() {
    _userStatsController.sink.add(UserStats(
        count: _users.length,
        online: _users.values.where((user) => user.online).length,
        favorite: _users.values.where((user) => user.favorite).length));
  }

  void search(String searchTerm) {
    this._searchTerm = searchTerm;

    _updateUsers();
  }

  void toggleFavorite(String id) {
    _updateUser(id, (user) => user.copyWith(favorite: !user.favorite));
  }

  User addUser({User user}) {
    if (user == null) {
      final id = (_userIdSeed++).toString();
      user = User(id: id, name: 'User $id');
    }
    _users[user.id] = user;
    _updateUsers();

    return user;
  }

  User removeUser(String id) {
    final user = _users.remove(id);
    if (user != null) {
      _updateUsers();
    }
    return user;
  }

  void dispose() {
    _onlineTimer.cancel();
    _usersController.close();
    _userController.close();
    _userStatsController.close();
  }
}
