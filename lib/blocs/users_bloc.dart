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

  // visible user list stream
  final StreamController<List<User>> _usersController =
      StreamController<List<User>>();
  // online user state stream
  final StreamController<User> _onlineUserController =
      StreamController<User>.broadcast();
  // visible user statistics stream
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
    _onlineTimer = Timer.periodic(Duration(seconds: 1), _onTick);
  }

  Stream<UserStats> get userStatsStream => _userStatsController.stream;
  Stream<List<User>> get usersStream => _usersController.stream;
  Stream<User> get onlineUserStream => _onlineUserController.stream;

  void _onTick(Timer timer) {
    final rnd = Random();
    // toggle online/offline state of random 5% of the users every second
    for (var i = 0; i < _allUsers.length * .05; i++) {
      final user = _allUsers[rnd.nextInt(_allUsers.length)];
      user.online = !user.online;

      _onlineUserController.sink.add(user);
    }

    // update stats after online states have changed
    _updateUserStats();
  }

  void _updateUserStats() {
    _userStatsController.sink.add(UserStats(
        count: _visibleUsers.length,
        online: _visibleUsers.where((user) => user.online).length,
        favorite: _visibleUsers.where((user) => user.favorite).length));
  }

  void search(String searchTerm) {
    // clear visible users
    _visibleUsers.clear();

    // filter visible users based on search term
    if (searchTerm == null || searchTerm.isEmpty) {
      _visibleUsers.addAll(_allUsers);
    } else {
      _visibleUsers.addAll(_allUsers.where(
          (u) => u.name.toLowerCase().contains(searchTerm.toLowerCase())));
    }

    _usersController.sink.add(_visibleUsers);

    // update stats after filtering visible users
    _updateUserStats();
  }

  void toggleFavorite(User user){
    user.favorite = !user.favorite;

    // update stats after toggling favorite
    _updateUserStats();
  }

  UserBloc createBloc(User user) {
    return UserBloc(user,this);
  }

  void dispose() {
    _onlineTimer.cancel();
    _usersController.close();
    _onlineUserController.close();
    _userStatsController.close();
  }
}
