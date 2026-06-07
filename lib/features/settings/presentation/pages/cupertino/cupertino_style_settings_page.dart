import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/cupertino/cupertino_style_page_scaffold.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/settings_bloc.dart';
import '../../widgets/cupertino/cupertino_style_app_update_alert_card.dart';
import '../../widgets/cupertino/groups/cupertino_style_about_group.dart';
import '../../widgets/cupertino/groups/cupertino_style_app_settings_group.dart';
import '../../widgets/cupertino/groups/cupertino_style_help_and_support_group.dart';
import '../../widgets/cupertino/groups/cupertino_style_more_group.dart';
import '../../widgets/cupertino/groups/cupertino_style_servers_group.dart';
import '../../widgets/cupertino/cupertino_style_onesignal_alert_card.dart';
import '../../widgets/cupertino/cupertino_style_register_server_button.dart';

class CupertinoStyleSettingsPage extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const CupertinoStyleSettingsPage({
    super.key,
    this.showBackButton = false,
    this.previousPageTitle,
  });

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return CupertinoStyleSettingsView(
      showBackButton: showBackButton,
      previousPageTitle: previousPageTitle,
    );
  }
}

class CupertinoStyleSettingsView extends StatefulWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const CupertinoStyleSettingsView({
    super.key,
    required this.showBackButton,
    this.previousPageTitle,
  });

  @override
  State<CupertinoStyleSettingsView> createState() => _CupertinoStyleSettingsViewState();
}

class _CupertinoStyleSettingsViewState extends State<CupertinoStyleSettingsView> {
  @override
  Widget build(BuildContext context) {
    return CupertinoStylePageScaffold(
      showBackButton: widget.showBackButton,
      previousPageTitle: widget.previousPageTitle,
      middle: const Text(LocaleKeys.settings_title).tr(),
      child: Column(
        children: [
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              state as SettingsSuccess;

              if (state.appSettings.appUpdateAvailable) {
                return const CupertinoStyleAppUpdateAlertCard();
              }

              return const SizedBox.shrink();
            },
          ),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              if (state is SettingsSuccess &&
                  (!state.appSettings.oneSignalBannerDismissed || state.appSettings.oneSignalConsented)) {
                return const CupertinoStyleOnesignalAlertCard();
              }

              return const SizedBox.shrink();
            },
          ),
          Expanded(
            child: ListView(
              children: const [
                CupertinoStyleServersGroup(),
                CupertinoStyleRegisterServerButton(),
                CupertinoStyleAppSettingsGroup(),
                CupertinoStyleHelpAndSupportGroup(),
                CupertinoStyleMoreGroup(),
                CupertinoStyleAboutGroup(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
