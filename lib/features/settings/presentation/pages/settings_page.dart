import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/widgets/scaffold_with_inner_drawer.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../onesignal/presentation/bloc/onesignal_health_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/app_update_alert_banner.dart';
import '../widgets/groups/app_settings_group.dart';
import '../widgets/groups/help_and_support_group.dart';
import '../widgets/groups/more_group.dart';
import '../widgets/groups/servers_group.dart';
import '../widgets/register_server_button.dart';
import '../widgets/settings_alert_banner.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return const SettingsView();
  }
}

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<OneSignalHealthBloc>().add(OneSignalHealthCheck());

    return ScaffoldWithInnerDrawer(
      title: const Text(LocaleKeys.settings_title).tr(),
      body: Column(
        children: [
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              state as SettingsSuccess;

              if (state.appSettings.appUpdateAvailable) {
                return const AppUpdateAlertBanner();
              }

              return const SizedBox(height: 0, width: 0);
            },
          ),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              if (state is SettingsSuccess && (!state.appSettings.oneSignalBannerDismissed || state.appSettings.oneSignalConsented)) {
                return const SettingsAlertBanner();
              }

              return const SizedBox(height: 0, width: 0);
            },
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: const [
                ServersGroup(),
                Gap(8),
                RegisterServerButton(),
                Gap(8),
                AppSettingsGroup(),
                Gap(8),
                HelpAndSupportGroup(),
                Gap(8),
                MoreGroup(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
