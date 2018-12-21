import 'dart:async';
import 'package:bloc_test/blocs/bloc_provider.dart';
import 'package:bloc_test/blocs/users_bloc.dart';
import 'package:bloc_test/models/user.dart';

class UserBloc implements BlocBase {
  final User user;
  final UsersBloc usersBloc;
  final StreamSubscription<User> _onlineSubscription;
  final StreamController<User> _userController = StreamController<User>();

  UserBloc(this.user, this.usersBloc)
      // listen for online state changes for this user only 
      : _onlineSubscription =
            usersBloc.onlineUserStream.where((u) => user == u).listen(null) {
    print('UserBloc ctor ${user.name}');

    // signal user change on online state changes
    _onlineSubscription.onData((user) {
      assert(user == this.user);
      _userController.sink.add(user);
    });
  }

  Stream<User> get userStream => _userController.stream;

  void toggleFavorite() {
    usersBloc.toggleFavorite(user);

    // signal user change
    _userController.sink.add(user);
  }

  void dispose() {
    print('UserBloc dispose ${user.name}');
    _userController.close();
    _onlineSubscription.cancel();
  }
}
