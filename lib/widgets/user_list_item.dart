import 'package:flutter/material.dart';
import 'package:bloc_test/blocs/bloc_provider.dart';
import 'package:bloc_test/blocs/bloc_state.dart';
import 'package:bloc_test/blocs/user_bloc.dart';
import 'package:bloc_test/blocs/users_bloc.dart';
import 'package:bloc_test/models/user.dart';
import 'package:bloc_test/pages/user_page.dart';
import 'package:bloc_test/widgets/circle_avatar_border.dart';
import 'package:bloc_test/widgets/online_indicator.dart';
import 'package:bloc_test/widgets/selectable_circle_avatar.dart';

class UserListItem extends StatefulWidget {
  final User user;
  const UserListItem({@required this.user, Key key}) : super(key: key);

  @override
  _UserListItemState createState() => _UserListItemState();
}

class _UserListItemState extends BlocState<UserListItem, UserBloc> {
  @override
  UserBloc createBloc() {
    return UserBloc(
        user: widget.user, usersBloc: BlocProvider.of<UsersBloc>(context));
  }

  @override
  Widget build(BuildContext context) {
    final usersBloc = BlocProvider.of<UsersBloc>(context);
    return StreamBuilder(
        initialData: widget.user,
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
            leading: StreamBuilder(
                initialData: usersBloc.multiSelect,
                stream: usersBloc.multiSelectStream,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) =>
                    SelectableCircleAvatar(
                        icon: Icon(Icons.person),
                        selecting: snapshot.data,
                        selected: user.selected,
                        onPressed: bloc.toggleSelect)),
            trailing: IconButton(
              icon: user.favorite
                  ? Icon(Icons.favorite, color: Colors.red)
                  : Icon(Icons.favorite_border),
              onPressed: usersBloc.multiSelect ? null : bloc.toggleFavorite,
            ),
            onTap: () {
              if (usersBloc.multiSelect) {
                bloc.toggleSelect();
              } else {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => UserPage(user)));
              }
            },
            onLongPress: bloc.toggleSelect
          );
        });
  }
}
