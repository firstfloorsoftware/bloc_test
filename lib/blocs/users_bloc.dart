import 'dart:async';
import 'dart:math';
import 'package:bloc_test/blocs/bloc_provider.dart';
import 'package:bloc_test/blocs/value_stream.dart';
import 'package:bloc_test/models/selection_state.dart';
import 'package:bloc_test/models/user.dart';
import 'package:bloc_test/models/user_stats.dart';

class UsersBloc extends BlocBase {
  final List<User> _users = List<User>();
  int _userIdSeed = 0;
  Timer _onlineTimer;

  // signal search term changes
  final ValueStreamController<String> _searchTermController =
      ValueStreamController<String>();
  // broadcast selection state changes
  final ValueStreamController<SelectionState> _selectionStateController =
      ValueStreamController<SelectionState>.broadcast(
          seedValue: SelectionState());
  // signal user list changes
  final StreamController<List<User>> _usersController =
      StreamController<List<User>>();
  // broadcast user changes
  final StreamController<User> _userController =
      StreamController<User>.broadcast();
  // signal user statistics
  final StreamController<UserStats> _userStatsController =
      StreamController<UserStats>();

  UsersBloc() {
    // create users
    for (var i = 0; i < 100; i++) {
      _users.add(createUser());
    }
    _userIdSeed = _users.length;

    // initialize users stream
    search(null);

    // start a timer to emulate online/offline behavior
    _onlineTimer = Timer.periodic(Duration(seconds: 1), _onTick);
  }

  ValueStream<String> get searchTerm => _searchTermController.stream;
  ValueStream<SelectionState> get selectionState =>
      _selectionStateController.stream;
  Stream<List<User>> get users => _usersController.stream;
  Stream<User> get user => _userController.stream;
  Stream<UserStats> get userStats => _userStatsController.stream;

  void _onTick(Timer timer) {
    if (_users.length == 0){
      return;
    }
    // toggle online/offline state of 10 random users
    final rnd = Random();

    for (var i = 0; i < 10; i++) {
      // get random user
      final index = rnd.nextInt(_users.length);
      final user = _users[index];

      // update online state
      user.online = !user.online;
      _userController.add(user);
    }

    // update stats once, and not for every user update
    _updateUserStats();
  }

  void _updateUsers() {
    // filter users based on search term
    final term = searchTerm.value;
    final users = term == null || term.isEmpty
        ? _users
        : _users
            .where(
                (user) => user.name.toLowerCase().contains(term.toLowerCase()))
            .toList();

    // signal listeners
    _usersController.add(users);

    // update stats
    _updateUserStats();
  }

  void _updateUserStats() {
    _userStatsController.add(UserStats(
        count: _users.length,
        online: _users.where((u) => u.online).length,
        favorite: _users.where((u) => u.favorite).length));
  }

  void _updateSelectionState() {
    final selectedUsers = _users.where((u) => u.selected).toList();
    final state = SelectionState(
      count: selectedUsers.length,
      favoriteCount: selectedUsers.where((u) => u.favorite).length,
      allSelected: selectedUsers.length == _users.length,
    );

    _selectionStateController.add(state);
  }

  void _selectAll(bool select) {
    _users.forEach((u) => u.selected = select);
    _updateSelectionState();
  }

  void selectAll() => _selectAll(true);

  void unselectAll() => _selectAll(false);

  void search(String searchTerm) {
    _searchTermController.add(searchTerm);
    _updateUsers();
  }

  void toggleFavorite(User user) {
    user.favorite = !user.favorite;
    _userController.add(user);
    _updateUserStats();
  }

  void toggleSelected(User user) {
    user.selected = !user.selected;
    _userController.add(user);

    _updateSelectionState();
  }

  void favoriteSelected({bool favorite = true}) {
    _users.where((u) => u.selected).forEach((u) {
      u.favorite = favorite;
      _userController.add(u);
    });
    _updateSelectionState();
    _updateUserStats();
  }

  List<User> removeSelected() {
    final selected = _users.where((u) => u.selected).toList();
    _users.removeWhere((u) => u.selected);
    _updateUsers();
    _updateSelectionState();

    return selected;
  }

  User createUser() {
    final id = (_userIdSeed++).toString().padLeft(3, '0');
    return User(id: id, name: 'User $id');
  }

  void addUser({User user}) {
    user = user ?? createUser();

    // make sure user is unselected
    user.selected = false;

    // insert user at sorted location
    int index = _users.indexWhere((u) => u.name.compareTo(user.name) >= 0);
    if (index == -1) {
      _users.add(user);
    } else {
      _users.insert(index, user);
    }
    _updateUsers();
  }

  void removeUser(User user) {
    if (_users.remove(user)) {
      _updateUsers();
      if (user.selected) {
        _updateSelectionState();
      }
    }
  }

  void dispose() {
    _onlineTimer.cancel();
    _searchTermController.close();
    _selectionStateController.close();
    _usersController.close();
    _userController.close();
    _userStatsController.close();
  }
}
