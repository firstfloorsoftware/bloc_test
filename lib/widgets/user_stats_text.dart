import 'package:flutter/material.dart';
import 'package:bloc_test/models/user_stats.dart';

class UserStatsText extends StatelessWidget {
  final UserStats stats;

  const UserStatsText(this.stats);

  @override
  Widget build(BuildContext context) {
    final String text = stats != null && stats.count > 0
        ? '${stats.count} user${stats.count != 1 ? 's' : ''}, ${stats.online} online, ${stats.favorite} favorite${stats.favorite != 1 ? 's' : ''}'
        : 'No users found';

    return Text(text,
        style: Theme.of(context).textTheme.body1.copyWith(color: Colors.grey));
  }
}
