import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../widgets/ios/groups/about_ios_group.dart';
import '../../widgets/ios/groups/app_settings_ios_group.dart';
import '../../widgets/ios/groups/help_and_support_ios_group.dart';
import '../../widgets/ios/groups/more_ios_group.dart';
import '../../widgets/ios/groups/server_ios_group.dart';
import '../../widgets/ios/register_server_ios_button.dart';

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
      middle: const Text(LocaleKeys.settings_title).tr(),
      child: Column(
        children: [
          //TODO: Banners for update and onesignal issues
          Expanded(
            child: ListView(
              // padding: const EdgeInsets.symmetric(vertical: 8.0),
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
