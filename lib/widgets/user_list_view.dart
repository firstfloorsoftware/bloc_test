import 'package:flutter/material.dart';
import 'package:bloc_test/blocs/bloc_provider.dart';
import 'package:bloc_test/blocs/users_bloc.dart';
import 'package:bloc_test/models/user.dart';
import 'package:bloc_test/widgets/user_list_item.dart';

class UserListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final usersBloc = BlocProvider.of<UsersBloc>(context);

    return StreamBuilder(
      stream: usersBloc.usersStream,
      builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data.isNotEmpty) {
          return ListView.separated(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) => UserListItem(
                    user: snapshot.data[index],
                    key: Key(snapshot.data[index].id),
                  ),
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(height: 1));
        }
        return Center(child: Text('No users found'));
      },
    );
  }
}
