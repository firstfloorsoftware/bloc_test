import 'package:flutter/material.dart';
import 'package:bloc_test/blocs/bloc_provider.dart';
import 'package:bloc_test/blocs/bloc_state.dart';
import 'package:bloc_test/blocs/user_bloc.dart';
import 'package:bloc_test/blocs/users_bloc.dart';
import 'package:bloc_test/models/user.dart';
import 'package:bloc_test/widgets/online_indicator.dart';

class UserPage extends StatefulWidget {
  final User user;

  const UserPage(this.user);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends BlocState<UserPage, UserBloc> {
  @override
  UserBloc createBloc() {
    return UserBloc(
        user: widget.user, usersBloc: BlocProvider.of<UsersBloc>(context));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        initialData: bloc.user.value,
        stream: bloc.user.stream,
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          final user = snapshot.data;
          return Scaffold(
              appBar: AppBar(
                title: Text(user.name),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(16),
                      child: CircleAvatar(
                          radius: 100, child: Icon(Icons.person, size: 100))),
                  Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            OnlineIndicator(online: user.online),
                            Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text(user.online ? 'Online' : 'Offline'))
                          ])),
                  IconButton(
                      icon: user.favorite
                          ? Icon(Icons.favorite, color: Colors.red)
                          : Icon(Icons.favorite_border),
                      onPressed: bloc.toggleFavorite)
                ],
              ));
        });
  }
}
