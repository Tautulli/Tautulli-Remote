import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/settings_bloc.dart';
import '../../widgets/ios/app_update_ios_alert_card.dart';
import '../../widgets/ios/groups/about_ios_group.dart';
import '../../widgets/ios/groups/app_settings_ios_group.dart';
import '../../widgets/ios/groups/help_and_support_ios_group.dart';
import '../../widgets/ios/groups/more_ios_group.dart';
import '../../widgets/ios/groups/servers_ios_group.dart';
import '../../widgets/ios/onesignal_ios_alert_card.dart';
import '../../widgets/ios/register_server_ios_button.dart';

class SettingsIosPage extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const SettingsIosPage({
    super.key,
    this.showBackButton = false,
    this.previousPageTitle,
  });

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return SettingsIosView(
      showBackButton: showBackButton,
      previousPageTitle: previousPageTitle,
    );
  }
}

class SettingsIosView extends StatefulWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const SettingsIosView({
    super.key,
    required this.showBackButton,
    this.previousPageTitle,
  });

  @override
  State<SettingsIosView> createState() => _SettingsIosViewState();
}

class _SettingsIosViewState extends State<SettingsIosView> {
  @override
  Widget build(BuildContext context) {
    return PageScaffoldCupertino(
      showBackButton: widget.showBackButton,
      previousPageTitle: widget.previousPageTitle,
      middle: const Text(LocaleKeys.settings_title).tr(),
      child: Column(
        children: [
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              state as SettingsSuccess;

              if (state.appSettings.appUpdateAvailable) {
                return const AppUpdateIosAlertCard();
              }

              return const SizedBox.shrink();
            },
          ),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              if (state is SettingsSuccess &&
                  (!state.appSettings.oneSignalBannerDismissed || state.appSettings.oneSignalConsented)) {
                return const OneSignalIosAlertCard();
              }

              return const SizedBox.shrink();
            },
          ),
          Expanded(
            child: ListView(
              children: const [
                ServersIosGroup(),
                RegisterServerIosButton(),
                AppSettingsIosGroup(),
                HelpAndSupportIosGroup(),
                MoreIosGroup(),
                AboutIosGroup(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
