import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../../../../../../core/widgets/cupertino/cupertino_style_refresh_page.dart';
import '../../../domain/entities/notification_log_entry.dart';
import '../../bloc/notification_logs_bloc.dart';
import '../base/notification_logs_table_headers.dart';
import '../base/notification_logs_table_row.dart';

class CupertinoStyleNotificationLogsTable extends StatelessWidget {
  final Completer<void> refreshCompleter;
  final List<NotificationLogEntry> logs;

  const CupertinoStyleNotificationLogsTable({
    super.key,
    required this.refreshCompleter,
    required this.logs,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoStyleRefreshPage(
      onRefresh: () {
        context.read<NotificationLogsBloc>().add(NotificationLogsLoad());
        return refreshCompleter.future;
      },
      sliver: SliverStickyHeader(
        header: const NotificationLogsTableHeaders(),
        sliver: SliverList.builder(
          itemCount: logs.length,
          itemBuilder: (context, index) {
            return NotificationLogsTableRow(
              logs[index],
              backgroundColor: (index % 2 == 0) ? CupertinoColors.darkBackgroundGray : null,
            );
          },
        ),
      ),
    );
  }
}
