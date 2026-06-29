import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:f_logs/model/flog/log.dart';
import 'package:f_logs/model/flog/log_level.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../dependency_injection.dart' as di;
import '../../../../../core/helpers/logging_helper.dart';
import '../../../../../core/pages/material/material_style_status_page.dart';
import '../../../../../core/widgets/material/material_style_page_body.dart';
import '../../../../../core/widgets/material/material_style_refresh_indicator.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/logging_bloc.dart';
import '../../bloc/logging_export_bloc.dart';
import '../../widgets/material/bottom_sheets/material_style_logging_actions_bottom_sheet.dart';
import '../../widgets/material/bottom_sheets/material_style_logging_filter_bottom_sheet.dart';
import '../../widgets/material/material_style_logging_table.dart';

class MaterialStyleLoggingPage extends StatelessWidget {
  const MaterialStyleLoggingPage({super.key});

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
      child: const MaterialStyleLoggingView(),
    );
  }
}

class MaterialStyleLoggingView extends StatefulWidget {
  const MaterialStyleLoggingView({super.key});

  @override
  State<MaterialStyleLoggingView> createState() => _MaterialStyleLoggingViewState();
}

class _MaterialStyleLoggingViewState extends State<MaterialStyleLoggingView> {
  late Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  void dispose() {
    if (!_refreshCompleter.isCompleted) _refreshCompleter.complete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return BlocListener<LoggingExportBloc, LoggingExportState>(
      listener: (context, state) {
        if (state is LoggingExportFailure) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).colorScheme.error,
              content: Text(
                LocaleKeys.logs_export_failed_message,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onError,
                ),
              ).tr(),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: const Text(LocaleKeys.app_logs_title).tr(),
          centerTitle: defaultTargetPlatform == TargetPlatform.iOS,
          actions: _appbarActions(),
        ),
        body: MaterialStylePageBody(
          child: MaterialStyleRefreshIndicator(
            onRefresh: () {
              context.read<LoggingBloc>().add(LoggingLoad());

              return _refreshCompleter.future;
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
                  return MaterialStyleStatusPage(
                    scrollable: true,
                    message: LocaleKeys.logs_failed_to_load_message.tr(),
                  );
                }
                if (state is LoggingSuccess) {
                  if (state.logs.isEmpty) {
                    return MaterialStyleStatusPage(
                      scrollable: true,
                      message: LocaleKeys.logs_empty_message.tr(),
                    );
                  } else {
                    List<Log> filteredLogs = filterLogs(
                      level: state.level,
                      logs: state.logs,
                    );

                    if (filteredLogs.isEmpty) {
                      return MaterialStyleStatusPage(
                        scrollable: true,
                        message: LocaleKeys.logs_empty_filter_message.tr(),
                      );
                    }

                    return MaterialStyleLoggingTable(filteredLogs);
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
            return IconButton(
              icon: FaIcon(
                FontAwesomeIcons.filter,
                size: 20,
                color: state.level != LogLevel.ALL
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (_) => BlocProvider.value(
                  value: context.read<LoggingBloc>(),
                  child: MaterialStyleLoggingFilterBottomSheet(
                    initialValue: state.level,
                  ),
                ),
              ),
            );
          }
          return IconButton(
            icon: FaIcon(
              FontAwesomeIcons.filter,
              color: Theme.of(context).colorScheme.onSurface,
              size: 20,
            ),
            onPressed: null,
          );
        },
      ),
      IconButton(
        icon: FaIcon(
          FontAwesomeIcons.sliders,
          color: Theme.of(context).colorScheme.onSurface,
          size: 20,
        ),
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: context.read<LoggingBloc>()),
              BlocProvider.value(value: context.read<LoggingExportBloc>()),
            ],
            child: const MaterialStyleLoggingActionsBottomSheet(),
          ),
        ),
      ),
    ];
  }
}
