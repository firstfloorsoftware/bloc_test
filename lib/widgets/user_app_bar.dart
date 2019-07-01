import 'package:flutter/material.dart';
import 'package:bloc_test/blocs/bloc_provider.dart';
import 'package:bloc_test/blocs/users_bloc.dart';
import 'package:bloc_test/models/selection_state.dart';
import 'package:bloc_test/widgets/search_text_field.dart';

class UserAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final usersBloc = BlocProvider.of<UsersBloc>(context);

    return StreamBuilder(
        initialData: usersBloc.selectionState.value,
        stream: usersBloc.selectionState,
        builder:
            (BuildContext context, AsyncSnapshot<SelectionState> snapshot) {
          final selectionState = snapshot.data;

          return StreamBuilder(
              initialData: usersBloc.searchTerm.value,
              stream: usersBloc.searchTerm,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                final searchTerm = snapshot.data;

                if (selectionState.isSelecting) {
                  // multi-select mode with favorite and remove actions
                  final favorite =
                      selectionState.favoriteCount != selectionState.count;
                  return AppBar(
                    title: Text('${selectionState.count}'),
                    leading: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: usersBloc.unselectAll),
                    actions: <Widget>[
                      IconButton(
                          icon: Icon(favorite
                              ? Icons.favorite
                              : Icons.favorite_border),
                          onPressed: () =>
                              usersBloc.favoriteSelected(favorite: favorite)),
                      IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => onRemoveSelected(context))
                    ],
                  );
                } else if (searchTerm != null) {
                  // search mode
                  return AppBar(
                      title: SearchTextField(
                          searchTerm: searchTerm,
                          onChanged: usersBloc.search),
                      leading: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          usersBloc.search(null);
                        },
                      ));
                } else {
                  // default mode
                  return AppBar(
                      title: Text('Users'),
                      leading: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            usersBloc.search('');
                          }));
                }
              });
        });
  }

  void onRemoveSelected(BuildContext context) {
    final usersBloc = BlocProvider.of<UsersBloc>(context);
    final users = usersBloc.removeSelected();

    // hide current snackbar
    final scaffold = Scaffold.of(context);
    scaffold.hideCurrentSnackBar(reason: SnackBarClosedReason.hide);

    // display snackbar
    final snackBar = SnackBar(
      content:
          Text('${users.length} user${users.length == 1 ? '' : 's'} removed'),
      action: SnackBarAction(
          label: 'Undo',
          onPressed: () =>
              // re-add removed users
              users.forEach((u) => usersBloc.addUser(user: u))),
    );
    scaffold.showSnackBar(snackBar);
  }
}
