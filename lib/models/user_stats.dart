import 'package:flutter/foundation.dart';

class UserStats {
  final int count;
  final int online;
  final int favorite;

  const UserStats(
      {@required this.count, @required this.online, @required this.favorite});
}
