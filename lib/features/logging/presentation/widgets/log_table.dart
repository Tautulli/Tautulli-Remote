// @dart=2.9

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/log_format_helper.dart';
import '../../../../translations/locale_keys.g.dart';
import '../bloc/load_logs_bloc.dart';
import 'log_table_row.dart';
import 'log_table_row_with_header.dart';

class LogTable extends StatelessWidget {
  final Completer refreshCompleter;
  final List<Log> logs;

  const LogTable({
    Key key,
    @required this.refreshCompleter,
    @required this.logs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    if (logs.isEmpty) {
      return RefreshIndicator(
        color: Theme.of(context).accentColor,
        onRefresh: () {
          context.read<LogsBloc>().add(LogsLoad());
          return refreshCompleter.future;
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                height: constraints.maxHeight,
                child: Center(
                  child: const Text(
                    LocaleKeys.logs_empty,
                    style: TextStyle(fontSize: 18),
                  ).tr(),
                ),
              ),
            );
          },
        ),
      );
    }
    return RefreshIndicator(
      color: Theme.of(context).accentColor,
      onRefresh: () {
        context.read<LogsBloc>().add(LogsLoad());
        return refreshCompleter.future;
      },
      child: Scrollbar(
        controller: _scrollController,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: logs.length,
          itemBuilder: (context, index) {
            //? Do this to create a list of formatted log maps in the Bloc instead?
            Map<String, dynamic> logMap =
                LogFormatHelper.formatLog(logs[index]);

            if (index == 0) {
              return Column(
                children: <Widget>[
                  LogTableRowWithHeader(
                    index: index,
                    logMap: logMap,
                  ),
                ],
              );
            }

            return LogTableRow(
              index: index,
              logMap: logMap,
            );
          },
        ),
      ),
    );
  }
}
