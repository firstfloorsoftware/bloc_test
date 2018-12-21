import 'package:flutter/material.dart';
import 'package:bloc_test/blocs/bloc_provider.dart';
import 'package:bloc_test/blocs/users_bloc.dart';
import 'package:bloc_test/widgets/user_list_view.dart';
import 'package:bloc_test/models/user_stats.dart';

class UsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final usersBloc = BlocProvider.of<UsersBloc>(context);
    return Scaffold(
        appBar: AppBar(
            title: TextField(
                decoration: InputDecoration(
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
                        AsyncSnapshot<UserStats> snapshot) {
                      if (snapshot.hasData) {
                        var stats = snapshot.data;
                        return Text(
                            '${stats.count} users, ${stats.online} online',
                            style: Theme.of(context)
                                .textTheme
                                .body1
                                .copyWith(color: Colors.grey));
                      }
                      return Container();
                    }))
          ],
        ));
  }
}
