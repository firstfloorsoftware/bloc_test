import 'package:flutter/material.dart';

class OnlineIndicator extends StatelessWidget {
  final bool online;

  const OnlineIndicator({this.online = true});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: online ? Colors.green : Colors.red, shape: BoxShape.circle));
  }
}
