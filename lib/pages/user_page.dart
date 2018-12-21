import 'package:flutter/material.dart';
import 'package:bloc_test/blocs/bloc_provider.dart';
import 'package:bloc_test/blocs/user_bloc.dart';
import 'package:bloc_test/blocs/users_bloc.dart';
import 'package:bloc_test/models/user.dart';
import 'package:bloc_test/widgets/online_indicator.dart';

class UserPage extends StatelessWidget {
  final User user;

  const UserPage(this.user);

  @override
  Widget build(BuildContext context) {
    final usersBloc = BlocProvider.of<UsersBloc>(context);
    final userBloc = usersBloc.createBloc(user);
    return BlocProvider<UserBloc>(
        bloc: userBloc,
        child: StreamBuilder(
            initialData: userBloc.user,
            stream: userBloc.userStream,
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
                              radius: 100,
                              child: Icon(Icons.person, size: 100))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          OnlineIndicator(online: user.online),
                          Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text(user.online ? 'Online' : 'Offline'))
                        ],
                      )
                    ],
                  ));
            }));
  }
}
