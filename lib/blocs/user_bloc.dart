import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:bloc_test/blocs/bloc_provider.dart';
import 'package:bloc_test/blocs/users_bloc.dart';
import 'package:bloc_test/models/user.dart';

class UserBloc implements BlocBase {
  final User user;
  final UsersBloc usersBloc;
  final StreamSubscription<User> _subscription;
  final StreamController<User> _userController = StreamController<User>();

  UserBloc({@required this.user, @required this.usersBloc})
      // listen for changes of this user
      : _subscription = usersBloc.userStream
            .where((u) => u == user)
            .listen(null) {
    // signal user change
    _subscription.onData((user) {
      _userController.sink.add(user);
    });
  }

  Stream<User> get userStream => _userController.stream;

  void toggleFavorite() {
    usersBloc.toggleFavorite(user);
  }

  void toggleSelected(){
    usersBloc.toggleSelected(user);
  }

  void dispose() {
    _userController.close();
    _subscription.cancel();
  }
}
