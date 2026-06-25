import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_notched_cupertino_list_tile.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_page_scaffold.dart';
import '../../../../../../translations/locale_keys.g.dart';
import 'cupertino_style_logging_page.dart';
import 'cupertino_style_notification_logs_page.dart';

class CupertinoStyleLogsPage extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const CupertinoStyleLogsPage({
    super.key,
    this.showBackButton = true,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoStylePageScaffold(
      showBackButton: showBackButton,
      previousPageTitle: previousPageTitle,
      middle: const Text(LocaleKeys.logs_title).tr(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoStyleListSection(
              headerText: LocaleKeys.device_logs_title.tr(),
              children: [
                CupertinoStyleNotchedCupertinoListTile(
                  leading: const Icon(
                    CupertinoIcons.device_phone_portrait,
                    color: ThemeHelper.cupertinoListTileIconColor,
                  ),
                  trailing: const CupertinoListTileChevron(),
                  titleText: LocaleKeys.app_logs_title.tr(),
                  onTap: () => Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => CupertinoStyleLoggingPage(
                        previousPageTitle: LocaleKeys.logs_title.tr(),
                      ),
                    ),
                  ),
                ),
                CupertinoStyleNotchedCupertinoListTile(
                  leading: const Icon(
                    CupertinoIcons.bell_fill,
                    color: ThemeHelper.cupertinoListTileIconColor,
                  ),
                  trailing: const CupertinoListTileChevron(),
                  titleText: LocaleKeys.notification_logs_title.tr(),
                  onTap: () => Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => CupertinoStyleNotificationLogsPage(
                        previousPageTitle: LocaleKeys.logs_title.tr(),
                      ),
                    ),
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
