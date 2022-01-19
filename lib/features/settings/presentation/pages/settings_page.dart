import 'package:flutter/material.dart';

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
      body: SafeArea(
        child: ListView(
          children: const [
            ServersGroup(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: RegisterServerButton(),
            ),
            AppSettingsGroup(),
            HelpAndSupportGroup(),
            MoreGroup(),
          ],
        ),
      ),
    );
  }
}
