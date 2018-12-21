import 'package:flutter/material.dart';
import 'package:bloc_test/blocs/bloc_provider.dart';
import 'package:bloc_test/blocs/users_bloc.dart';
import 'package:bloc_test/widgets/user_list_view.dart';

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
                onChanged: (text) => usersBloc.search(text))),
        body: UserListView());
  }
}
