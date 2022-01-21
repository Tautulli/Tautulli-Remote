import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../widgets/active_connection_indicator.dart';
import '../widgets/custom_header_list_tile.dart';
import '../widgets/custom_header_type_dialog.dart';
import '../widgets/settings_group.dart';
import '../widgets/settings_list_tile.dart';

class ServerSettingsPage extends StatelessWidget {
  const ServerSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ServerSettingsView();
  }
}

class ServerSettingsView extends StatelessWidget {
  const ServerSettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Server Name'),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.trash),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            SettingsGroup(
              heading: 'Connection Details',
              settingsListTiles: [
                SettingsListTile(
                  leading: const FaIcon(FontAwesomeIcons.networkWired),
                  title: 'Primary Connection Address',
                  subtitle: 'https://tautulli.domain.com',
                  trailing: const ActiveConnectionIndicator(),
                  onTap: () {},
                ),
                SettingsListTile(
                  leading: const FaIcon(FontAwesomeIcons.networkWired),
                  title: 'Secondary Connection Address',
                  subtitle: 'https://plexpy.domain.com',
                  onTap: () {},
                ),
                SettingsListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.key,
                    color: Theme.of(context).textTheme.subtitle2!.color,
                  ),
                  title: 'Device Token',
                  subtitle: 'goc4waof_NQ9PiwzST1bJB9GHD6cQ_4R',
                  disabled: true,
                  onTap: () {},
                ),
              ],
            ),
            const Gap(8),
            const SettingsGroup(
              heading: 'Custom HTTP Headers',
              settingsListTiles: [
                CustomerHeaderListTile(
                  title: 'Authorization',
                  subtitle: 'Value',
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    child: const Text('Add Custom HTTP Header'),
                    onPressed: () async => await showDialog(
                      context: context,
                      builder: (context) => const CustomHeaderTypeDialog(),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(8),
            SettingsGroup(
              heading: 'Other',
              settingsListTiles: [
                Material(
                  child: ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(
                          width: 35,
                          child: FaIcon(FontAwesomeIcons.windowMaximize),
                        ),
                      ],
                    ),
                    title: const Text('Open Server Name in browser'),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
