import 'package:flutter/foundation.dart';

class User {
  final String id;
  String firstName;
  String lastName;
  String thumbnailUri;
  bool online;
  bool favorite;

  String get fullName => "$firstName $lastName";

  User({@required this.id, @required this.firstName, @required this.lastName, this.thumbnailUri, this.online = false, this.favorite = false});
  
  User.fromJson(Map<String, dynamic> json)
    : id = json['login']['uuid'],
      firstName = _capitalize(json['name']['first']),
      lastName = _capitalize(json['name']['last']),
      thumbnailUri = json['picture']['thumbnail'],
      online = false,
      favorite = false;

  static String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}
