import 'package:flutter/material.dart';
import 'package:bloc_test/blocs/bloc_provider.dart';
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

class _UserListItemState extends State<UserListItem> {
  UserBloc userBloc;

  @override
  void initState() {
    final usersBloc = BlocProvider.of<UsersBloc>(context);
    userBloc = usersBloc.createBloc(widget.user);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
        bloc: userBloc,
        child: StreamBuilder(
            initialData: userBloc.user,
            stream: userBloc.userStream,
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
                  onPressed: userBloc.toggleFavorite,
                ),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => UserPage(user)));
                },
              );
            }));
  }
}
