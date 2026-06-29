import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/pages/material/material_style_status_page.dart';
import '../../../../../../core/widgets/material/material_style_page_body.dart';
import '../../../../../../core/widgets/material/material_style_refresh_indicator.dart';
import '../../../../../../dependency_injection.dart' as di;
import '../../../../../../translations/locale_keys.g.dart';
import '../../bloc/notification_logs_bloc.dart';
import '../../widgets/material/dialogs/material_style_clear_notification_logs_dialog.dart';
import '../../widgets/material/material_style_notification_logs_table.dart';

class MaterialStyleNotificationLogsPage extends StatelessWidget {
  const MaterialStyleNotificationLogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<NotificationLogsBloc>()..add(NotificationLogsLoad()),
      child: const MaterialStyleNotificationLogsView(),
    );
  }
}

class MaterialStyleNotificationLogsView extends StatefulWidget {
  const MaterialStyleNotificationLogsView({super.key});

  @override
  State<MaterialStyleNotificationLogsView> createState() => _MaterialStyleNotificationLogsViewState();
}

class _MaterialStyleNotificationLogsViewState extends State<MaterialStyleNotificationLogsView> {
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
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(LocaleKeys.notification_logs_title).tr(),
        actions: [
          BlocBuilder<NotificationLogsBloc, NotificationLogsState>(
            builder: (context, state) {
              return IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.solidCircleXmark,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: state is NotificationLogsSuccess
                    ? () => showDialog(
                        context: context,
                        builder: (_) => BlocProvider.value(
                          value: context.read<NotificationLogsBloc>(),
                          child: const MaterialStyleClearNotificationLogsDialog(),
                        ),
                      )
                    : null,
              );
            },
          ),
        ],
      ),
      body: MaterialStylePageBody(
        child: MaterialStyleRefreshIndicator(
          onRefresh: () {
            context.read<NotificationLogsBloc>().add(NotificationLogsLoad());
            return _refreshCompleter.future;
          },
          child: BlocConsumer<NotificationLogsBloc, NotificationLogsState>(
            listener: (context, state) {
              if (state is NotificationLogsSuccess) {
                _refreshCompleter.complete();
                _refreshCompleter = Completer();
              }
            },
            builder: (context, state) {
              if (state is NotificationLogsFailure) {
                return MaterialStyleStatusPage(
                  scrollable: true,
                  message: LocaleKeys.logs_failed_to_load_message.tr(),
                );
              }
              if (state is NotificationLogsSuccess) {
                if (state.logs.isEmpty) {
                  return MaterialStyleStatusPage(
                    scrollable: true,
                    message: LocaleKeys.logs_empty_message.tr(),
                  );
                }
                return MaterialStyleNotificationLogsTable(state.logs);
              }
              return const SizedBox(height: 0, width: 0);
            },
          ),
        ),
      ),
    );
  }
}
