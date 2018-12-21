import 'package:flutter/material.dart';
import 'package:bloc_test/blocs/bloc_provider.dart';
import 'package:bloc_test/blocs/users_bloc.dart';
import 'package:bloc_test/pages/users_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<UsersBloc>(
        bloc: UsersBloc(),
        child: MaterialApp(
          title: 'Bloc test',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: UsersPage(),
        ));
  }
}
