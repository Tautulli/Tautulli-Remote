import 'package:flutter/cupertino.dart';
import 'package:tautulli_remote/features/settings/presentation/widgets/groups/servers_group.dart';
import 'package:tautulli_remote/features/settings/presentation/widgets/ios/groups/app_settings_ios_group.dart';

import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';

class SettingsIosPage extends StatelessWidget {
  const SettingsIosPage({super.key});

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return const SettingsIosView();
  }
}

class SettingsIosView extends StatefulWidget {
  const SettingsIosView({super.key});

  @override
  State<SettingsIosView> createState() => _SettingsIosViewState();
}

class _SettingsIosViewState extends State<SettingsIosView> {
  @override
  Widget build(BuildContext context) {
    return PageScaffoldCupertino(
      title: Text('Settings'),
      child: Column(
        children: [
          //TODO: Banners for update and onesignal issues
          Expanded(
            child: ListView(
              // padding: const EdgeInsets.symmetric(vertical: 8.0),
              children: const [
                AppSettingsIosGroup(),
                // Text('test'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
