import 'package:flutter/foundation.dart';
import 'package:bloc_test/models/selectable.dart';

class User with Selectable {
  final String id;
  String name;
  bool online;
  bool favorite;

  User(
      {@required this.id,
      @required this.name,
      this.online = false,
      this.favorite = false});
}