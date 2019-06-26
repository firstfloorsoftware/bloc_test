import 'package:flutter/material.dart';
import 'package:bloc_test/models/user_stats.dart';

class UserStatsText extends StatelessWidget {
  final UserStats stats;

  const UserStatsText(this.stats);

  @override
  Widget build(BuildContext context) {
    final text = stats == null || stats.count == 0
        ? 'No users found'
        : [
            if (stats.count > 0)
              '${stats.count} user${stats.count != 1 ? 's' : ''}'
            else
              'No users found',
            if (stats.online > 0) '${stats.online} online',
            if (stats.favorite > 0)
              '${stats.favorite} favorite${stats.favorite != 1 ? 's' : ''}'
          ].join(', ');

    return Text(text,
        style: Theme.of(context).textTheme.body1.copyWith(color: Colors.grey));
  }
}
