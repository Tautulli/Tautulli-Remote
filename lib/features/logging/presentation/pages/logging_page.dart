import 'dart:async';

import 'package:f_logs/model/flog/log.dart';
import 'package:f_logs/model/flog/log_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../dependency_injection.dart' as di;
import '../../../../core/pages/status_page.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../core/widgets/themed_refresh_indicator.dart';
import '../bloc/logging_bloc.dart';
import '../bloc/logging_export_bloc.dart';
import '../widgets/clear_logging_dialog.dart';
import '../widgets/logging_table.dart';

class LoggingPage extends StatelessWidget {
  const LoggingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<LoggingBloc>()..add(LoggingLoad()),
        ),
        BlocProvider(
          create: (context) => di.sl<LoggingExportBloc>(),
        ),
      ],
      child: const LoggingView(),
    );
  }
}

class LoggingView extends StatefulWidget {
  const LoggingView({Key? key}) : super(key: key);

  @override
  State<LoggingView> createState() => _LoggingViewState();
}

class _LoggingViewState extends State<LoggingView> {
  late Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Logs'),
        actions: _appbarActions(),
      ),
      body: PageBody(
        child: ThemedRefreshIndicator(
          onRefresh: () {
            context.read<LoggingBloc>().add(LoggingLoad());

            return _refreshCompleter.future;
          },
          child: BlocListener<LoggingExportBloc, LoggingExportState>(
            listener: (context, state) {
              if (state is LoggingExportSuccess) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Logs exported'),
                    action: SnackBarAction(
                      label: 'HOW TO ACCESS LOGS',
                      onPressed: () async {
                        await launch(
                          'https://github.com/Tautulli/Tautulli-Remote/wiki/Features#logs',
                        );
                      },
                    ),
                  ),
                );
              }
            },
            child: BlocConsumer<LoggingBloc, LoggingState>(
              listener: (context, state) {
                if (state is LoggingSuccess) {
                  _refreshCompleter.complete();
                  _refreshCompleter = Completer();
                }
              },
              builder: (context, state) {
                if (state is LoggingFailure) {
                  return const StatusPage(
                    scrollable: true,
                    message: 'Failed to load logs.',
                  );
                }
                if (state is LoggingSuccess) {
                  if (state.logs.isEmpty) {
                    return const StatusPage(
                      scrollable: true,
                      message: 'No logs found.',
                    );
                  } else {
                    List<Log> filteredLogs = _filterLogs(
                      level: state.level,
                      logs: state.logs,
                    );

                    if (filteredLogs.isEmpty) {
                      return const StatusPage(
                        scrollable: true,
                        message: 'No logs for the selected filter.',
                      );
                    }

                    return LoggingTable(filteredLogs);
                  }
                }
                return const SizedBox(height: 0, width: 0);
              },
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _appbarActions() {
    return [
      BlocBuilder<LoggingBloc, LoggingState>(
        builder: (context, state) {
          if (state is LoggingSuccess) {
            return PopupMenuButton(
              icon: FaIcon(
                FontAwesomeIcons.filter,
                color: state.level != LogLevel.ALL
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.secondaryVariant,
              ),
              onSelected: (LogLevel value) {
                context.read<LoggingBloc>().add(
                      LoggingSetLevel(value),
                    );
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: Text(
                      'All',
                      style: TextStyle(
                        color: state.level == LogLevel.ALL
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.secondaryVariant,
                      ),
                    ),
                    value: LogLevel.ALL,
                  ),
                  PopupMenuItem(
                    child: Text(
                      'Debug',
                      style: TextStyle(
                        color: state.level == LogLevel.DEBUG
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.secondaryVariant,
                      ),
                    ),
                    value: LogLevel.DEBUG,
                  ),
                  PopupMenuItem(
                    child: Text(
                      'Info',
                      style: TextStyle(
                        color: state.level == LogLevel.INFO
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.secondaryVariant,
                      ),
                    ),
                    value: LogLevel.INFO,
                  ),
                  PopupMenuItem(
                    child: Text(
                      'Warning',
                      style: TextStyle(
                        color: state.level == LogLevel.WARNING
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.secondaryVariant,
                      ),
                    ),
                    value: LogLevel.WARNING,
                  ),
                  PopupMenuItem(
                    child: Text(
                      'Error',
                      style: TextStyle(
                        color: state.level == LogLevel.ERROR
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.secondaryVariant,
                      ),
                    ),
                    value: LogLevel.ERROR,
                  ),
                ];
              },
            );
          }
          return const IconButton(
            icon: FaIcon(
              FontAwesomeIcons.filter,
            ),
            onPressed: null,
          );
        },
      ),
      PopupMenuButton(
        onSelected: (value) async {
          final loggingBloc = context.read<LoggingBloc>();

          if (value == 'export') {
            if (await Permission.storage.request().isGranted) {
              context.read<LoggingExportBloc>().add(
                    LoggingExportStart(loggingBloc),
                  );
            }
          }
          if (value == 'clear') {
            showDialog(
              context: context,
              builder: (context) => ClearLoggingDialog(loggingBloc),
            );
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            child: Text('Export logs'),
            value: 'export',
          ),
          const PopupMenuItem(
            child: Text('Clear logs'),
            value: 'clear',
          ),
        ],
      ),
    ];
  }

  List<Log> _filterLogs({
    required LogLevel level,
    required List<Log> logs,
  }) {
    List<Log> filteredLogs = [];

    for (Log log in logs) {
      // Always display error, severe, or fatal
      if ([
        LogLevel.ERROR,
        LogLevel.SEVERE,
        LogLevel.FATAL,
      ].contains(log.logLevel)) {
        filteredLogs.add(log);
      }
      // If level is warning then also display warning log level
      else if (level == LogLevel.WARNING && log.logLevel == LogLevel.WARNING) {
        filteredLogs.add(log);
      }
      // If level is info then also display info and warning
      else if (level == LogLevel.INFO &&
          [
            LogLevel.INFO,
            LogLevel.WARNING,
          ].contains(log.logLevel)) {
        filteredLogs.add(log);
      }
      // If level is debug then also display debug, info, and warning
      else if (level == LogLevel.DEBUG &&
          [
            LogLevel.DEBUG,
            LogLevel.INFO,
            LogLevel.WARNING,
          ].contains(log.logLevel)) {
        filteredLogs.add(log);
      } else if (level == LogLevel.ALL) {
        filteredLogs.add(log);
      }
    }

    return filteredLogs;
  }
}
