import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/widgets/page_body.dart';
import '../../../onesignal/presentation/bloc/onesignal_health_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/app_settings_group.dart';
import '../widgets/help_and_support_group.dart';
import '../widgets/more_group.dart';
import '../widgets/register_server_button.dart';
import '../widgets/servers_group.dart';
import '../widgets/settings_alert_banner.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return const SettingsView();
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<OneSignalHealthBloc>().add(OneSignalHealthCheck());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              if (state is SettingsSuccess &&
                  !state.appSettings.oneSignalBannerDismissed) {
                return const SettingsAlertBanner();
              }

              return const SizedBox(height: 0, width: 0);
            },
          ),
          Expanded(
            child: PageBody(
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: const [
                  ServersGroup(),
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
          ),
        ],
      ),
    );
  }
}
