import 'package:flutter/foundation.dart';

class User implements Comparable<User> {
  final String id;
  final String name;
  final bool online;
  final bool favorite;

  @override
  int compareTo(User other) {
    return name.compareTo(other.name);
  }

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

class UserWithIndex {
  final User user;
  final int index;

  const UserWithIndex({@required this.user, @required this.index});
}
