import 'package:f_logs/model/flog/log.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/theme_helper.dart';
import 'logging_table_headers.dart';
import 'logging_table_row.dart';

class LoggingTable extends StatelessWidget {
  final List<Log> logs;

  const LoggingTable(
    this.logs, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const LoggingTableHeaders(),
        Expanded(
          child: ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              return LoggingTableRow(
                logs[index],
                backgroundColor: (index % 2 == 0) ? Theme.of(context).colorScheme.surface : ThemeHelper.darkenedColor(Theme.of(context).colorScheme.surface),
              );
            },
          ),
        ),
      ],
    );
  }
}
