import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/widgets/ios/cupertino_list_tile_external.dart';
import '../../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../../../logging/presentation/pages/ios/logging_ios_page.dart';

class HelpAndSupportIosGroup extends StatelessWidget {
  const HelpAndSupportIosGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCupertinoListSection(
      headerText: LocaleKeys.help_and_support_title.tr(),
      children: [
        CustomNotchedCupertinoListTile(
          leading: FaIcon(
            FontAwesomeIcons.github,
            color: ThemeHelper.cupertinoListTileIconColor(),
            size: 23,
          ),
          trailing: const CupertinoListTileExternal(),
          titleText: LocaleKeys.wiki_title.tr(),
          onTap: () async {
            await launchUrlString(
              mode: LaunchMode.externalApplication,
              'https://github.com/Tautulli/Tautulli-Remote/wiki',
            );
          },
        ),
        CustomNotchedCupertinoListTile(
          leading: FaIcon(
            FontAwesomeIcons.discord,
            color: ThemeHelper.cupertinoListTileIconColor(),
            size: 19.2,
          ),
          trailing: const CupertinoListTileExternal(),
          titleText: LocaleKeys.discord_title.tr(),
          onTap: () async {
            await launchUrlString(
              mode: LaunchMode.externalApplication,
              'https://tautulli.com/discord.html',
            );
          },
        ),
        CustomNotchedCupertinoListTile(
          leading: FaIcon(
            FontAwesomeIcons.redditAlien,
            color: ThemeHelper.cupertinoListTileIconColor(),
            size: 23,
          ),
          trailing: const CupertinoListTileExternal(),
          titleText: LocaleKeys.reddit_title.tr(),
          onTap: () async {
            await launchUrlString(
              mode: LaunchMode.externalApplication,
              'https://www.reddit.com/r/Tautulli/',
            );
          },
        ),
        CustomNotchedCupertinoListTile(
          leading: FaIcon(
            FontAwesomeIcons.github,
            color: ThemeHelper.cupertinoListTileIconColor(),
            size: 23,
          ),
          trailing: const CupertinoListTileExternal(),
          titleText: LocaleKeys.bugs_and_feature_requests_title.tr(),
          onTap: () async {
            await launchUrlString(
              mode: LaunchMode.externalApplication,
              'https://github.com/Tautulli/Tautulli-Remote/issues',
            );
          },
        ),
        CustomNotchedCupertinoListTile(
          leading: Icon(
            CupertinoIcons.list_bullet,
            color: ThemeHelper.cupertinoListTileIconColor(),
          ),
          trailing: const CupertinoListTileChevron(),
          titleText: LocaleKeys.tautulli_remote_logs_title.tr(),
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => LoggingIosPage(
                previousPageTitle: LocaleKeys.settings_title.tr(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
