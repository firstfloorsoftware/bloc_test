import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:bloc_test/blocs/bloc_provider.dart';
import 'package:bloc_test/blocs/users_bloc.dart';
import 'package:bloc_test/blocs/value_stream.dart';
import 'package:bloc_test/models/user.dart';

class UserBloc implements BlocBase {
  final UsersBloc usersBloc;
  final StreamSubscription<User> _subscription;
  final ValueStreamController<User> _userController = ValueStreamController<User>();

  UserBloc({@required User user, @required this.usersBloc})
      // listen for changes of this user
      : _subscription = usersBloc.user
            .where((u) => u == user)
            .listen(null) {

    // add initial value
    _userController.add(user);

    // subscribe user change
    _subscription.onData((user) {
      _userController.add(user);
    });
  }

  ValueStream<User> get user => _userController.valueStream;

  void toggleFavorite() {
    usersBloc.toggleFavorite(user.value);
  }

  void toggleSelected(){
    usersBloc.toggleSelected(user.value);
  }

  void dispose() {
    _userController.close();
    _subscription.cancel();
  }
}
