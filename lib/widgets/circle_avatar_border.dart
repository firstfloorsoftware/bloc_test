import 'package:flutter/material.dart';

class CircleAvatarBorder extends StatelessWidget {
  final Widget child;
  final double radius;
  final double width;
  final Color color;

  const CircleAvatarBorder(
      {@required this.child,
      this.radius = 20,
      this.color = Colors.grey,
      this.width = 2});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 2 * radius,
        height: 2 * radius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: width),
        ),
        child: child);
  }
}
