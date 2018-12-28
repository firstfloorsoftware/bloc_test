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

                return StreamBuilder(
                    stream: usersBloc.multiSelectStream,
                    initialData: usersBloc.multiSelect,
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      final multiSelect = snapshot.data;

                      return multiSelect
                          // not dismissable in multi-select mode 
                          ? UserListItem(
                              user: user,
                            )
                          : Dismissible(
                              key: Key(user.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                  color: Colors.red,
                                  padding: EdgeInsets.symmetric(horizontal: 28),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(child: Container()),
                                      Icon(Icons.delete, color: Colors.white)
                                    ],
                                  )),
                              child: UserListItem(
                                user: user,
                              ),
                              onDismissed: (direction) =>
                                  onDismissed(context, user));
                    });
              },
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(height: 1));
        });
  }

  void onDismissed(BuildContext context, User user) {
    final usersBloc = BlocProvider.of<UsersBloc>(context);
    final removedUser = usersBloc.removeUser(user);

    // hide current snackbar
    final scaffold = Scaffold.of(context);
    scaffold.hideCurrentSnackBar(reason: SnackBarClosedReason.hide);

    // display snackbar
    final snackBar = SnackBar(
      content: Text('${user.name} removed'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () =>
            usersBloc.insertUser(removedUser.index, removedUser.user),
      ),
    );
    scaffold.showSnackBar(snackBar);
  }
}
