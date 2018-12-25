import 'dart:async';
import 'dart:math';
import 'package:bloc_test/blocs/bloc_provider.dart';
import 'package:bloc_test/models/user.dart';
import 'package:bloc_test/models/user_stats.dart';

class UsersBloc implements BlocBase {
  final List<User> _users = List<User>();
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
      _users.add(User(id: id, name: 'User $id'));
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
    final rnd = Random();

    for (var i = 0; i < 10; i++) {
      // get random user
      final index = rnd.nextInt(_users.length);
      final user = _users[index];

      // update online state
      _updateUser(index, user.copyWith(online: !user.online));
    }

    // update stats once, and not for every user update
    _updateUserStats();
  }

  void _updateUser(int index, User user) {
    // update user
    _users[index] = user;

    // signal update
    _userController.sink.add(user);
  }

  void _updateUsers() {
    // filter users based on search term
    final users = _searchTerm == null || _searchTerm.isEmpty
        ? _users
        : _users
            .where((user) =>
                user.name.toLowerCase().contains(_searchTerm.toLowerCase()))
            .toList();

    // signal listeners
    _usersController.sink.add(users);

    // update stats
    _updateUserStats();
  }

  void _updateUserStats() {
    _userStatsController.sink.add(UserStats(
        count: _users.length,
        online: _users.where((user) => user.online).length,
        favorite: _users.where((user) => user.favorite).length));
  }

  void search(String searchTerm) {
    this._searchTerm = searchTerm;
    _updateUsers();
  }

  void toggleFavorite(String userId) {
    final index = _users.indexWhere((user) => user.id == userId);
    if (index != -1) {
      final user = _users[index];
      // update user
      _updateUser(index, user.copyWith(favorite: !user.favorite));
      // update stats
      _updateUserStats();
    }
  }

  void addUser() {
    final id = (_userIdSeed++).toString();
    final user = User(id: id, name: 'User $id');

    _users.add(user);
    _updateUsers();
  }

  void insertUser(int index, User user) {
    _users.insert(index, user);
    _updateUsers();
  }

  UserWithIndex removeUser(String userId) {
    final index = _users.indexWhere((user) => user.id == userId);
    if (index != -1) {
      final user = _users.removeAt(index);
      _updateUsers();
      return UserWithIndex(user: user, index: index);
    }
    return null;
  }

  void dispose() {
    _onlineTimer.cancel();
    _usersController.close();
    _userController.close();
    _userStatsController.close();
  }
}
