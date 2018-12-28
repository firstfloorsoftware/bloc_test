import 'dart:async';
import 'dart:math';
import 'package:bloc_test/blocs/search_bloc.dart';
import 'package:bloc_test/models/user.dart';
import 'package:bloc_test/models/user_stats.dart';

class UsersBloc extends SearchBloc {
  final List<User> _users = List<User>();
  final List<User> _selectedUsers = List<User>();
  int _userIdSeed = 0;
  Timer _onlineTimer;

  // signal selected user list changes
  final StreamController<List<User>> _selectedUsersController =
      StreamController<List<User>>.broadcast();
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

  List<User> get selectedUsers => _selectedUsers;
  Stream<List<User>> get selectedUsersStream => _selectedUsersController.stream;
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
      user.online = !user.online;
      _userController.sink.add(user);
    }

    // update stats once, and not for every user update
    _updateUserStats();
  }

  void _updateUsers() {
    // filter users based on search term
    final users = searchTerm == null || searchTerm.isEmpty
        ? _users
        : _users
            .where((user) =>
                user.name.toLowerCase().contains(searchTerm.toLowerCase()))
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

  void _updateSelectedUsers() {
    _selectedUsers.clear();
    _selectedUsers.addAll(_users.where((u) => u.selected));
    _selectedUsersController.sink.add(_selectedUsers);
  }

  void search(String searchTerm) {
    super.search(searchTerm);
    _updateUsers();
  }

  void toggleFavorite(User user) {
    user.favorite = !user.favorite;
    _userController.sink.add(user);
    _updateUserStats();
  }

  void toggleSelected(User user) {
    user.selected = !user.selected;
    _userController.sink.add(user);

    _updateSelectedUsers();
  }

  void unselectAll() {
    _selectedUsers.forEach((u) => u.selected = false);
    _updateSelectedUsers();
  }

  void favoriteSelected({bool favorite = true}) {
    _selectedUsers.forEach((u) {
      u.favorite = favorite;
      _userController.sink.add(u);
    });
    _updateSelectedUsers();
    _updateUserStats();
  }

  void removeSelected() {
    _users.removeWhere((u) => u.selected);
    _updateUsers();
    _updateSelectedUsers();
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
    super.dispose();
    _onlineTimer.cancel();
    _selectedUsersController.close();
    _usersController.close();
    _userController.close();
    _userStatsController.close();
  }
}
