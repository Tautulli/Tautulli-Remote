import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/pages/cupertino/cupertino_style_status_page.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_page_scaffold.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_refresh_page.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/notification_logs_bloc.dart';
import '../../widgets/cupertino/cupertino_style_notification_logs_table.dart';
import '../../widgets/cupertino/dialogs/cupertino_style_clear_notification_logs_dialog.dart';

class CupertinoStyleNotificationLogsPage extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const CupertinoStyleNotificationLogsPage({
    super.key,
    this.showBackButton = true,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<NotificationLogsBloc>()..add(NotificationLogsLoad()),
      child: CupertinoStyleNotificationLogsView(
        showBackButton: showBackButton,
        previousPageTitle: previousPageTitle,
      ),
    );
  }
}

class CupertinoStyleNotificationLogsView extends StatefulWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const CupertinoStyleNotificationLogsView({
    super.key,
    required this.showBackButton,
    this.previousPageTitle,
  });

  @override
  State<CupertinoStyleNotificationLogsView> createState() =>
      _CupertinoStyleNotificationLogsViewState();
}

class _CupertinoStyleNotificationLogsViewState
    extends State<CupertinoStyleNotificationLogsView> {
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
    onRefresh() async {
      context.read<NotificationLogsBloc>().add(NotificationLogsLoad());
      return _refreshCompleter.future;
    }

    return CupertinoStylePageScaffold(
      showBackButton: widget.showBackButton,
      previousPageTitle: widget.previousPageTitle,
      middle: const Text(LocaleKeys.notification_logs_title).tr(),
      trailing: BlocProvider.value(
        value: context.read<NotificationLogsBloc>(),
        child: BlocBuilder<NotificationLogsBloc, NotificationLogsState>(
          builder: (context, state) {
            return CupertinoButton(
              padding: const EdgeInsets.all(8),
              onPressed: state is NotificationLogsSuccess
                  ? () => showCupertinoDialog(
                        context: context,
                        builder: (_) => BlocProvider.value(
                          value: context.read<NotificationLogsBloc>(),
                          child: const CupertinoStyleClearNotificationLogsDialog(),
                        ),
                      )
                  : null,
              child: const Icon(
                CupertinoIcons.xmark_circle_fill,
                color: ThemeHelper.cupertinoNavigationBarItemColor,
              ),
            );
          },
        ),
      ),
      child: BlocConsumer<NotificationLogsBloc, NotificationLogsState>(
        listener: (context, state) {
          if (state is NotificationLogsSuccess) {
            _refreshCompleter.complete();
            _refreshCompleter = Completer();
          }
        },
        builder: (context, state) {
          if (state is NotificationLogsFailure) {
            return CupertinoStyleRefreshPage(
              onRefresh: onRefresh,
              sliver: SliverFillRemaining(
                child: CupertinoStyleStatusPage(
                  message: LocaleKeys.logs_failed_to_load_message.tr(),
                ),
              ),
            );
          }
          if (state is NotificationLogsSuccess) {
            if (state.logs.isEmpty) {
              return CupertinoStyleRefreshPage(
                onRefresh: onRefresh,
                sliver: SliverFillRemaining(
                  child: CupertinoStyleStatusPage(
                    message: LocaleKeys.logs_empty_message.tr(),
                  ),
                ),
              );
            }
            return CupertinoStyleNotificationLogsTable(
              refreshCompleter: _refreshCompleter,
              logs: state.logs,
            );
          }
          return const SizedBox(height: 0, width: 0);
        },
      ),
    );
  }
}
