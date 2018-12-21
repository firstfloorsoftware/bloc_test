import 'package:flutter/material.dart';
import 'package:bloc_test/blocs/bloc_provider.dart';
import 'package:bloc_test/blocs/users_bloc.dart';
import 'package:bloc_test/models/user_stats.dart';
import 'package:bloc_test/widgets/user_list_view.dart';
import 'package:bloc_test/widgets/user_stats_text.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  bool _searching;

  @override
  Widget build(BuildContext context) {
    final usersBloc = BlocProvider.of<UsersBloc>(context);
    return Scaffold(
        appBar: AppBar(
            title: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.white)),
                style: Theme.of(context)
                    .textTheme
                    .subhead
                    .copyWith(color: Colors.white),
                onChanged: usersBloc.search)),
        body: Column(
          children: <Widget>[
            Expanded(child: UserListView()),
            Padding(
                padding: EdgeInsets.all(16),
                child: StreamBuilder(
                    stream: usersBloc.userStatsStream,
                    builder: (BuildContext context,
                            AsyncSnapshot<UserStats> snapshot) =>
                        UserStatsText(snapshot.data)))
          ],
        ));
  }
}
