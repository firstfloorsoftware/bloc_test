import 'package:flutter/foundation.dart';

class User {
  final String id;
  String name;
  bool online;
  bool favorite;
  bool selected;

  User(
      {@required this.id,
      @required this.name,
      this.online = false,
      this.favorite = false,
      this.selected = false});
}