import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String name;
  final bool online;
  final bool favorite;

  const User(
      {@required this.id,
      @required this.name,
      this.online = false,
      this.favorite = false});

  User copyWith({String name, bool online, bool favorite}) {
    return User(
        id: id,
        name: name ?? this.name,
        online: online ?? this.online,
        favorite: favorite ?? this.favorite);
  }
}
