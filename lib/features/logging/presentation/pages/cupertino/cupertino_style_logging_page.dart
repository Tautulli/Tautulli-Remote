import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:f_logs/model/flog/log.dart';
import 'package:f_logs/model/flog/log_level.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/pages/cupertino/cupertino_style_status_page.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_refresh_page.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_page_scaffold.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/logging_bloc.dart';
import '../../bloc/logging_export_bloc.dart';
import '../../widgets/cupertino/bottom_sheets/cupertino_style_logging_actions_bottom_sheet.dart';
import '../../widgets/cupertino/bottom_sheets/cupertino_style_logging_filter_bottom_sheet.dart';
import '../../widgets/cupertino/cupertino_style_logging_table.dart';

class CupertinoStyleLoggingPage extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const CupertinoStyleLoggingPage({
    super.key,
    this.showBackButton = true,
    this.previousPageTitle,
  });

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
      child: CupertinoStyleLoggingView(
        showBackButton: showBackButton,
        previousPageTitle: previousPageTitle,
      ),
    );
  }
}

class CupertinoStyleLoggingView extends StatefulWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const CupertinoStyleLoggingView({
    super.key,
    required this.showBackButton,
    this.previousPageTitle,
  });

  @override
  State<CupertinoStyleLoggingView> createState() => _CupertinoStyleLoggingViewState();
}

class _CupertinoStyleLoggingViewState extends State<CupertinoStyleLoggingView> {
  late Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    onRefresh() async {
      context.read<LoggingBloc>().add(LoggingLoad());

      return _refreshCompleter.future;
    }

    return CupertinoStylePageScaffold(
      showBackButton: widget.showBackButton,
      previousPageTitle: widget.previousPageTitle,
      middle: const Text(LocaleKeys.app_logs_title).tr(),
      trailing: BlocProvider.value(
        value: context.read<LoggingBloc>(),
        child: BlocProvider.value(
          value: context.read<LoggingExportBloc>(),
          child: _navBarActions(),
        ),
      ),
      child: BlocConsumer<LoggingBloc, LoggingState>(
        listener: (context, state) {
          if (state is LoggingSuccess) {
            _refreshCompleter.complete();
            _refreshCompleter = Completer();
          }
        },
        builder: (context, state) {
          if (state is LoggingFailure) {
            return CupertinoStyleRefreshPage(
              onRefresh: onRefresh,
              sliver: SliverFillRemaining(
                child: CupertinoStyleStatusPage(
                  message: LocaleKeys.logs_failed_to_load_message.tr(),
                ),
              ),
            );
          }
          if (state is LoggingSuccess) {
            if (state.logs.isEmpty) {
              return CupertinoStyleRefreshPage(
                onRefresh: onRefresh,
                sliver: SliverFillRemaining(
                  child: CupertinoStyleStatusPage(
                    message: LocaleKeys.logs_empty_message.tr(),
                  ),
                ),
              );
            } else {
              List<Log> filteredLogs = _filterLogs(
                level: state.level,
                logs: state.logs,
              );

              if (filteredLogs.isEmpty) {
                return CupertinoStyleRefreshPage(
                  onRefresh: onRefresh,
                  sliver: SliverFillRemaining(
                    child: CupertinoStyleStatusPage(
                      message: LocaleKeys.logs_empty_filter_message.tr(),
                    ),
                  ),
                );
              }

              return CupertinoStyleLoggingTable(
                refreshCompleter: _refreshCompleter,
                logs: filteredLogs,
              );
            }
          }
          return const SizedBox(height: 0, width: 0);
        },
      ),
    );
  }

  Widget _navBarActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocBuilder<LoggingBloc, LoggingState>(
          builder: (context, state) {
            if (state is LoggingSuccess) {
              return CupertinoButton(
                padding: const EdgeInsets.all(8),
                onPressed: () => showCupertinoModalPopup(
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: context.read<LoggingBloc>(),
                    child: CupertinoStyleLoggingFilterBottomSheet(
                      initialValue: state.level,
                    ),
                  ),
                ),
                child: Icon(
                  CupertinoIcons.line_horizontal_3_decrease,
                  color: ThemeHelper.cupertinoNavigationBarItemColor(),
                ),
              );
            }
            return const CupertinoButton(
              padding: EdgeInsets.all(8),
              onPressed: null,
              child: Icon(CupertinoIcons.line_horizontal_3_decrease),
            );
          },
        ),
        CupertinoButton(
          padding: const EdgeInsets.all(8),
          onPressed: () => showCupertinoModalPopup(
            context: context,
            builder: (_) => BlocProvider.value(
              value: context.read<LoggingBloc>(),
              child: BlocProvider.value(
                value: context.read<LoggingExportBloc>(),
                child: const CupertinoStyleLoggingActionsBottomSheet(),
              ),
            ),
          ),
          child: Icon(
            CupertinoIcons.slider_horizontal_3,
            color: ThemeHelper.cupertinoNavigationBarItemColor(),
          ),
        ),
      ],
    );
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
