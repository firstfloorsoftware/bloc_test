import 'package:flutter/material.dart';
import 'package:bloc_test/blocs/bloc_provider.dart';
import 'package:bloc_test/blocs/bloc_state.dart';
import 'package:bloc_test/blocs/user_bloc.dart';
import 'package:bloc_test/blocs/users_bloc.dart';
import 'package:bloc_test/models/user.dart';
import 'package:bloc_test/pages/user_page.dart';
import 'package:bloc_test/widgets/online_indicator.dart';

class UserListItem extends StatefulWidget {
  final User user;

  const UserListItem({@required this.user, Key key}) : super(key: key);

  @override
  _UserListItemState createState() => _UserListItemState();
}

class _UserListItemState extends BlocState<UserListItem, UserBloc> {
  @override
  UserBloc createBloc() {
    final usersBloc = BlocProvider.of<UsersBloc>(context);
    return usersBloc.createBloc(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        initialData: bloc.user,
        stream: bloc.userStream,
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          final user = snapshot.data;
          return ListTile(
            title: Row(children: <Widget>[
              Text(user.name),
              Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: user.online ? OnlineIndicator() : null)
            ]),
            leading: CircleAvatar(child: Icon(Icons.person)),
            trailing: IconButton(
              icon: user.favorite
                  ? Icon(Icons.favorite, color: Colors.red)
                  : Icon(Icons.favorite_border),
              onPressed: bloc.toggleFavorite,
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => UserPage(user)));
            },
          );
        });
  }
}
