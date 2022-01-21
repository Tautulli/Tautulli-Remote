import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/widgets/page_body.dart';
import '../widgets/app_settings_group.dart';
import '../widgets/help_and_support_group.dart';
import '../widgets/more_group.dart';
import '../widgets/register_server_button.dart';
import '../widgets/servers_group.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: PageBody(
        child: ListView(
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
    );
  }
}
