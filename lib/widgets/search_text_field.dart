import 'package:flutter/material.dart';

class SearchTextField extends StatefulWidget {
  final String searchTerm;
  final ValueChanged<String> onChanged;

  const SearchTextField({@required this.searchTerm, @required this.onChanged});

  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController(text: widget.searchTerm);
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.title;
    return TextField(
        controller: _controller,
        decoration: InputDecoration.collapsed(
            hintText: 'Search',
            hintStyle: titleStyle.copyWith(color: Colors.white30)),
        autofocus: true,
        autocorrect: false,
        style: titleStyle.copyWith(color: Colors.white),
        onChanged: widget.onChanged);
  }
}
