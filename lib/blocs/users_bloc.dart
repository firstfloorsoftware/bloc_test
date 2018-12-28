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
  bool _multiSelect = false;

  // signal user list changes
  final StreamController<List<User>> _usersController =
      StreamController<List<User>>();
  // signal user changes
  final StreamController<User> _userController =
      StreamController<User>.broadcast();
  // signal user statistics
  final StreamController<UserStats> _userStatsController =
      StreamController<UserStats>();
  final StreamController<bool> _multiSelectController =
      StreamController<bool>.broadcast();

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

  bool get multiSelect => _multiSelect;
  Stream<List<User>> get usersStream => _usersController.stream;
  Stream<User> get userStream => _userController.stream;
  Stream<UserStats> get userStatsStream => _userStatsController.stream;
  Stream<bool> get multiSelectStream => _multiSelectController.stream;

  void _onTick(Timer timer) {
    // toggle online/offline state of 10 random users
    final rnd = Random();

    for (var i = 0; i < 10; i++) {
      // get random user
      final index = rnd.nextInt(_users.length);
      final user = _users[index];

      // update online state
      user.online = !user.online;
      _userController.sink.add(user);
    }

    // update stats once, and not for every user update
    _updateUserStats();
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
        online: _users.where((u) => u.online).length,
        favorite: _users.where((u) => u.favorite).length));
  }

  void search(String searchTerm) {
    this._searchTerm = searchTerm;
    _updateUsers();
  }

  void toggleFavorite(User user) {
    user.favorite = !user.favorite;
    _userController.sink.add(user);
    _updateUserStats();
  }

  void toggleSelect(User user) {
    user.selected = !user.selected;
    _userController.sink.add(user);

    if (user.selected) {
      if (!_multiSelect) {
        _multiSelect = true;
        _multiSelectController.sink.add(_multiSelect);
      }
    } else if (_multiSelect && !_users.any((u) => u.selected)) {
      _multiSelect = false;
      _multiSelectController.sink.add(_multiSelect);
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

  UserWithIndex removeUser(User user) {
    final index = _users.indexOf(user);
    if (index != -1) {
      _users.removeAt(index);
      _updateUsers();
      return UserWithIndex(user: user, index: index);
    }
    return null;
  }

  void dispose() {
    _onlineTimer.cancel();
    _multiSelectController.close();
    _usersController.close();
    _userController.close();
    _userStatsController.close();
  }
}
