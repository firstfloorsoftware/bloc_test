import 'package:flutter/material.dart';

class AppSearchBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget title;
  final ValueChanged<String> onSearch;

  const AppSearchBar({@required this.title, @required this.onSearch});

  @override
  _AppSearchBarState createState() => _AppSearchBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AppSearchBarState extends State<AppSearchBar> {
  bool _searching = false;

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = Theme.of(context).textTheme.title;
    return AppBar(
        leading: IconButton(
            icon: Icon(_searching ? Icons.clear : Icons.search),
            onPressed: () {
              setState(() {
                _searching = !_searching;
                widget.onSearch(null);
              });
            }),
        title: _searching
            ? TextField(
                decoration: InputDecoration.collapsed(
                    hintText: 'Search',
                    hintStyle: titleStyle.copyWith(color: Colors.white30)),
                autofocus: true,
                autocorrect: false,
                style: titleStyle.copyWith(color: Colors.white),
                onChanged: widget.onSearch)
            : widget.title);
  }
}
