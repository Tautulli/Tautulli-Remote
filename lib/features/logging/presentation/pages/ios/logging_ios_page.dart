import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:f_logs/model/flog/log.dart';
import 'package:f_logs/model/flog/log_level.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/pages/ios/status_ios_page.dart';
import '../../../../../core/widgets/ios/cupertino_refresh_page.dart';
import '../../../../../core/widgets/ios/custom_cupertino_navigation_bar_back_button.dart';
import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/logging_bloc.dart';
import '../../bloc/logging_export_bloc.dart';
import '../../widgets/ios/logging_actions_action_sheet.dart';
import '../../widgets/ios/logging_filter_ios_bottom_sheet.dart';
import '../../widgets/ios/logging_ios_table.dart';

class LoggingIosPage extends StatelessWidget {
  final String? previousPageTitle;

  const LoggingIosPage({
    super.key,
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
      child: LoggingIosView(
        previousPageTitle: previousPageTitle,
      ),
    );
  }
}

class LoggingIosView extends StatefulWidget {
  final String? previousPageTitle;

  const LoggingIosView({
    super.key,
    this.previousPageTitle,
  });

  @override
  State<LoggingIosView> createState() => _LoggingIosViewState();
}

class _LoggingIosViewState extends State<LoggingIosView> {
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

    return PageScaffoldCupertino(
      middle: const Text(LocaleKeys.app_logs_title).tr(),
      leading: CustomCupertinoNavigationBarBackButton(
        previousPageTitle: widget.previousPageTitle,
      ),
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
            return CupertinoRefreshPage(
              onRefresh: onRefresh,
              sliver: SliverFillRemaining(
                child: StatusIosPage(
                  message: LocaleKeys.logs_failed_to_load_message.tr(),
                ),
              ),
            );
          }
          if (state is LoggingSuccess) {
            if (state.logs.isEmpty) {
              return CupertinoRefreshPage(
                onRefresh: onRefresh,
                sliver: SliverFillRemaining(
                  child: StatusIosPage(
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
                return CupertinoRefreshPage(
                  onRefresh: onRefresh,
                  sliver: SliverFillRemaining(
                    child: StatusIosPage(
                      message: LocaleKeys.logs_empty_filter_message.tr(),
                    ),
                  ),
                );
              }

              return LoggingIosTable(
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
    //TODO: Should I move all actions into a single button or just update the icons?
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocBuilder<LoggingBloc, LoggingState>(
          builder: (context, state) {
            if (state is LoggingSuccess) {
              return CupertinoButton(
                padding: const EdgeInsets.all(8),
                onPressed: () => showCupertinoSheet(
                  context: context,
                  pageBuilder: (_) => BlocProvider.value(
                    value: context.read<LoggingBloc>(),
                    child: LoggingFilterIosBottomSheet(
                      initialValue: state.level,
                    ),
                  ),
                ),
                child: Icon(
                  FontAwesomeIcons.filter,
                  color: ThemeHelper.cupertinoNavigationBarItemColor(),
                ),
              );
            }
            return const CupertinoButton(
              padding: EdgeInsets.all(8),
              onPressed: null,
              child: Icon(FontAwesomeIcons.filter),
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
                child: const LoggingActionsActionSheet(),
              ),
            ),
          ),
          child: Icon(
            Icons.more_horiz,
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
