import 'package:flutter/material.dart';
import 'package:bloc_test/blocs/bloc_provider.dart';
import 'package:bloc_test/blocs/users_bloc.dart';
import 'package:bloc_test/models/user_stats.dart';
import 'package:bloc_test/widgets/user_app_bar.dart';
import 'package:bloc_test/widgets/user_list_view.dart';
import 'package:bloc_test/widgets/user_stats_text.dart';

class UsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final usersBloc = BlocProvider.of<UsersBloc>(context);
    return Scaffold(
        appBar: UserAppBar(),
        body: Column(
          children: <Widget>[
            Expanded(child: UserListView()),
            Padding(
                padding: EdgeInsets.all(16),
                child: StreamBuilder(
                    stream: usersBloc.userStats,
                    builder: (BuildContext context,
                            AsyncSnapshot<UserStats> snapshot) =>
                        UserStatsText(snapshot.data)))
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add), onPressed: usersBloc.addUser));
  }
}
