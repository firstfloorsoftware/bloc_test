import 'package:flutter/material.dart';
import 'package:bloc_test/blocs/bloc_provider.dart';
import 'package:bloc_test/blocs/user_bloc.dart';
import 'package:bloc_test/blocs/users_bloc.dart';
import 'package:bloc_test/models/user.dart';

class UserListItem extends StatelessWidget {
  final User user;

  const UserListItem({@required this.user, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usersBloc = BlocProvider.of<UsersBloc>(context);
    final userBloc = usersBloc.createBloc(user);
    return BlocProvider<UserBloc>(
        bloc: userBloc,
        child: StreamBuilder(
            stream: userBloc.userStream,
            initialData: userBloc.user,
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              final user = snapshot.data;
              return ListTile(
                  title: Row(children: <Widget>[
                    Text(user.fullName),
                    Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: user.online
                            ? Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle))
                            : null)
                  ]),
                  leading:
                      CircleAvatar(backgroundImage: NetworkImage(user.thumbnailUri)),
                  trailing: IconButton(
                    icon: user.favorite
                        ? Icon(Icons.favorite, color: Colors.red)
                        : Icon(Icons.favorite_border),
                    onPressed: userBloc.toggleFavorite,
                  ));
            }));
  }
}
