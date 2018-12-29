import 'package:flutter/material.dart';
import 'package:bloc_test/blocs/bloc_provider.dart';
import 'package:bloc_test/blocs/users_bloc.dart';
import 'package:bloc_test/models/user.dart';
import 'package:bloc_test/widgets/search_text_field.dart';

class UserAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final usersBloc = BlocProvider.of<UsersBloc>(context);

    return StreamBuilder(
        initialData: usersBloc.selectedUsers.value,
        stream: usersBloc.selectedUsers.stream,
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          final selectedUsers = snapshot.data;

          return StreamBuilder(
              initialData: usersBloc.searchTerm.value,
              stream: usersBloc.searchTerm.stream,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                final searchTerm = snapshot.data;

                if (selectedUsers != null && selectedUsers.isNotEmpty) {
                  final noFavoriteSelected =
                    selectedUsers.any((u) => !u.favorite);
                  // multi-select mode with favorite and remove actions
                  return AppBar(
                    title: Text('${selectedUsers.length}'),
                    leading: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: usersBloc.unselectAll),
                    actions: <Widget>[
                      IconButton(
                          icon: Icon(noFavoriteSelected
                              ? Icons.favorite
                              : Icons.favorite_border),
                          onPressed: () => usersBloc.favoriteSelected(
                              favorite: noFavoriteSelected)),
                      IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: usersBloc.removeSelected)
                    ],
                  );
                } else if (searchTerm != null) {
                  // search mode
                  return AppBar(
                      title: SearchTextField(
                          searchTerm: usersBloc.searchTerm.value,
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
}
