import 'package:flutter/material.dart';
import 'package:bloc_test/widgets/circle_avatar_border.dart';

class SelectableCircleAvatar extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;
  final bool selected;
  final bool selecting;

  const SelectableCircleAvatar(
      {@required this.icon,
      @required this.onPressed,
      this.selected = false,
      this.selecting = false});

  @override
  Widget build(BuildContext context) {
    if (selecting) {
      return selected
          // selected state
          ? CircleAvatar(
              backgroundColor: Colors.grey,
              foregroundColor: Colors.white,
              child: IconButton(icon: Icon(Icons.check), onPressed: onPressed))
          // unselected state
          : CircleAvatarBorder(
              child: IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Container(),
                  onPressed: onPressed));
    }
    // default state
    return CircleAvatar(child: IconButton(icon: icon, onPressed: onPressed));
  }
}
