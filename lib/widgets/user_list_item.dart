import 'package:flutter/material.dart';
import 'package:bloc_test/blocs/bloc_provider.dart';
import 'package:bloc_test/blocs/users_bloc.dart';
import 'package:bloc_test/models/selection_state.dart';
import 'package:bloc_test/models/user.dart';
import 'package:bloc_test/pages/user_page.dart';
import 'package:bloc_test/widgets/online_indicator.dart';
import 'package:bloc_test/widgets/selectable_circle_avatar.dart';

class UserListItem extends StatelessWidget {
  final User user;
  const UserListItem({@required this.user, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<UsersBloc>(context);
    return StreamBuilder(
        initialData: user,
        stream: bloc.user.where((u) => u.id == user.id),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          final user = snapshot.data;

          return StreamBuilder(
              initialData: bloc.selectionState.value,
              stream: bloc.selectionState,
              builder: (BuildContext context,
                  AsyncSnapshot<SelectionState> snapshot) {
                final selectionState = snapshot.data;

                return Container(
                    color: user.selected
                        ? Colors.grey.shade200
                        : Colors.transparent,
                    child: Material(
                        color: Colors.transparent,
                        child: ListTile(
                            title: Row(children: <Widget>[
                              Text(user.name),
                              Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: user.online ? OnlineIndicator() : null)
                            ]),
                            leading: SelectableCircleAvatar(
                                icon: Icon(Icons.person),
                                selecting: selectionState.isMultiSelect,
                                selected: user.selected,
                                onPressed: () => bloc.toggleSelected(user)),
                            trailing: IconButton(
                                icon: user.favorite
                                    ? Icon(Icons.favorite, color: Colors.red)
                                    : Icon(Icons.favorite_border),
                                onPressed: selectionState.isMultiSelect
                                    ? null
                                    : () => bloc.toggleFavorite(user)),
                            onTap: selectionState.isMultiSelect
                                ? () => bloc.toggleSelected(user)
                                : () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => UserPage(user))),
                            onLongPress: () => bloc.toggleSelected(user))));
              });
        });
  }
}
