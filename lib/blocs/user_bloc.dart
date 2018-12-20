import 'dart:async';
import 'package:bloc_test/blocs/bloc_provider.dart';
import 'package:bloc_test/models/user.dart';

class UserBloc implements BlocBase {
  final User _user;
  final StreamController<User> _userController = StreamController<User>();
  final StreamSubscription<User> _onlineSubscription;

  UserBloc(this._user, this._onlineSubscription) {
    _onlineSubscription.onData((user) {
      assert(user == this._user);
      _userController.sink.add(user);
    });
  }

  Stream<User> get user => _userController.stream;

  void toggleFavorite() {
    _user.favorite = !_user.favorite;
    _userController.sink.add(_user);
  }

  void dispose() {
    _userController.close();
    _onlineSubscription.cancel();
  }
}
