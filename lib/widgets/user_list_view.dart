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
        return ListView.separated(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              final user = snapshot.data[index];
              return Dismissible(
                key: Key(user.id),
                background: Container(color: Colors.red),
                child: UserListItem(
                  user: user,
                ),
                onDismissed: (direction) {
                  User removedUser = usersBloc.removeUser(user.id);

                  // hide current snackbar
                  final scaffold = Scaffold.of(context);
                  scaffold.hideCurrentSnackBar(
                      reason: SnackBarClosedReason.hide);

                  // display snackbar
                  final snackBar = SnackBar(
                    content: Text('${user.name} removed'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () => usersBloc.addUser(user: removedUser),
                    ),
                  );
                  scaffold.showSnackBar(snackBar);
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                Divider(height: 1));
      },
    );
  }
}
