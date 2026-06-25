import 'package:flutter/material.dart';

import '../../../../../../core/helpers/theme_helper.dart';
import '../../../domain/entities/notification_log_entry.dart';
import '../base/notification_logs_table_headers.dart';
import '../base/notification_logs_table_row.dart';

class MaterialStyleNotificationLogsTable extends StatelessWidget {
  final List<NotificationLogEntry> logs;

  const MaterialStyleNotificationLogsTable(
    this.logs, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const NotificationLogsTableHeaders(),
        Expanded(
          child: ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              return NotificationLogsTableRow(
                logs[index],
                backgroundColor: (index % 2 == 0)
                    ? Theme.of(context).colorScheme.surface
                    : ThemeHelper.darkenedColor(Theme.of(context).colorScheme.surface),
              );
            },
          ),
        ),
      ],
    );
  }
}
