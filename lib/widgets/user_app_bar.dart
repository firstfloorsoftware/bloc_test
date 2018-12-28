import 'package:flutter/material.dart';
import 'package:bloc_test/blocs/bloc_provider.dart';
import 'package:bloc_test/blocs/users_bloc.dart';
import 'package:bloc_test/models/user.dart';

class UserAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final usersBloc = BlocProvider.of<UsersBloc>(context);

    return StreamBuilder(
        initialData: usersBloc.selectedUsers,
        stream: usersBloc.selectedUsersStream,
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          final selectedUsers = snapshot.data;

          return StreamBuilder(
              initialData: usersBloc.searchTerm,
              stream: usersBloc.searchTermStream,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                final searchTerm = snapshot.data;
                final selectedNoFavorite = selectedUsers.any((u) => !u.favorite);

                if (selectedUsers.isNotEmpty) {
                  // multi-select mode with favorite and remove action
                  return AppBar(
                    title: Text('${selectedUsers.length}'),
                    leading: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: usersBloc.unselectAll),
                    actions: <Widget>[
                      IconButton(
                          icon: Icon(selectedNoFavorite
                              ? Icons.favorite
                              : Icons.favorite_border),
                          onPressed: () => usersBloc.favoriteSelected(
                              favorite: selectedNoFavorite)),
                      IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: usersBloc.removeSelected)
                    ],
                  );
                } else if (searchTerm != null) {
                  final titleStyle = Theme.of(context).textTheme.title;
                  // search mode
                  return AppBar(
                      title: TextField(
                          decoration: InputDecoration.collapsed(
                              hintText: 'Search',
                              hintStyle:
                                  titleStyle.copyWith(color: Colors.white30)),
                          autofocus: true,
                          autocorrect: false,
                          style: titleStyle.copyWith(color: Colors.white),
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
