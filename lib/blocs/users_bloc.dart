import 'dart:async';
import 'dart:math';
import 'package:bloc_test/blocs/bloc_provider.dart';
import 'package:bloc_test/blocs/user_bloc.dart';
import 'package:bloc_test/models/user.dart';
import 'package:bloc_test/services/user_service.dart';

class UsersBloc implements BlocBase {
  List<User> _users;

  final StreamController<List<User>> _usersController =
      StreamController<List<User>>();
  final StreamController<User> _onlineUserController =
      StreamController<User>.broadcast();
  Timer _onlineTimer;
  Stream<List<User>> get users => _usersController.stream;

  UsersBloc() {
    UserService().randomUsers(100).then((users) {
      _users = users;

      // sort alphabetically on last name
      _users.sort((a, b) {
        return a.lastName.toLowerCase().compareTo(b.lastName.toLowerCase());
      });

      // notify listeners
      _usersController.sink.add(users);

      // start a timer to emulate online/offline behavior
      _onlineTimer = Timer.periodic(Duration(milliseconds: 1000), onTick);
    });
  }

  void onTick(Timer timer) {
    final rnd = Random();
    // toggle online/offline state of random 5% of the users every second
    for (var i = 0; i < _users.length * .05; i++) {
      var user = _users[rnd.nextInt(_users.length)];
      user.online = !user.online;

      _onlineUserController.sink.add(user);
    }
  }

  void search(String searchTerm) {
    if (searchTerm == null || searchTerm.isEmpty) {
      _usersController.sink.add(_users);
    } else {
      _usersController.sink.add(_users
          .where((u) =>
              u.fullName.toLowerCase().contains(searchTerm.toLowerCase()))
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
  }
}
