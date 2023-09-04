import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/device_info/device_info.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../../translations/locale_keys.g.dart';

class AppUpdateAlertBanner extends StatelessWidget {
  const AppUpdateAlertBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialBanner(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      leading: const FaIcon(
        FontAwesomeIcons.download,
        size: 30,
        color: TautulliColorPalette.notWhite,
      ),
      content: const Text(
        LocaleKeys.app_update_available_message,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: TautulliColorPalette.notWhite,
        ),
      ).tr(),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: TautulliColorPalette.notWhite,
          ),
          onPressed: () async {
            String platform = di.sl<DeviceInfo>().platform;

            if (platform == 'ios') {
              await launchUrlString(
                'https://apps.apple.com/us/app/tautulli-remote/id1570909086',
                mode: LaunchMode.externalApplication,
              );
            } else if (platform == 'android') {
              await launchUrlString(
                'https://play.google.com/store/apps/details?id=com.tautulli.tautulli_remote',
                mode: LaunchMode.externalApplication,
              );
            }
          },
          child: const Text(LocaleKeys.update_title).tr(),
        ),
      ],
    );
  }
}
