import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../core/device_info/device_info.dart';
import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_alert_card.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';

class CupertinoStyleAppUpdateAlertCard extends StatelessWidget {
  const CupertinoStyleAppUpdateAlertCard({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return CupertinoStyleAlertCard(
      tint: CupertinoTheme.of(context).primaryColor,
      leading: const Icon(
        CupertinoIcons.cloud_download_fill,
        color: ThemeHelper.cupertinoCardIconColor,
        size: 30,
      ),
      content: LocaleKeys.app_update_available_message.tr(),
      actions: [
        CupertinoButton(
          child: const Text(
            LocaleKeys.update_title,
            style: TextStyle(
              color: ThemeHelper.cupertinoAlertCardButtonTextColor,
            ),
          ).tr(),
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
        ),
      ],
    );
  }
}
