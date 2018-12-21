import 'dart:async';
import 'package:bloc_test/blocs/bloc_provider.dart';
import 'package:bloc_test/models/user.dart';

class UserBloc implements BlocBase {
  final User user;
  final StreamController<User> _userController = StreamController<User>();
  final StreamSubscription<User> _onlineSubscription;

  UserBloc(this.user, this._onlineSubscription) {
    print('UserBloc ctor ${user.name}');

    _onlineSubscription.onData((user) {
      assert(user == this.user);
      _userController.sink.add(user);
    });
  }

  Stream<User> get userStream => _userController.stream;

  void toggleFavorite() {
    user.favorite = !user.favorite;
    _userController.sink.add(user);
  }

  void dispose() {
    print('UserBloc dispose ${user.name}');
    _userController.close();
    _onlineSubscription.cancel();
  }
}
