import 'dart:async';

import 'package:f_logs/model/flog/log.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../../../../../core/widgets/ios/cupertino_refresh_page.dart';
import '../../bloc/logging_bloc.dart';
import '../logging_table_headers.dart';
import '../logging_table_row.dart';

class CupertinoStyleLoggingTable extends StatelessWidget {
  final Completer<void> refreshCompleter;
  final List<Log> logs;

  const CupertinoStyleLoggingTable({
    super.key,
    required this.refreshCompleter,
    required this.logs,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoRefreshPage(
      onRefresh: () {
        context.read<LoggingBloc>().add(LoggingLoad());

        return refreshCompleter.future;
      },
      sliver: SliverStickyHeader(
        header: const LoggingTableHeaders(),
        sliver: SliverList.builder(
          itemBuilder: (context, index) {
            return LoggingTableRow(
              logs[index],
              backgroundColor: (index % 2 == 0) ? CupertinoColors.darkBackgroundGray : null,
            );
          },
          itemCount: logs.length,
        ),
      ),
    );
  }
}
