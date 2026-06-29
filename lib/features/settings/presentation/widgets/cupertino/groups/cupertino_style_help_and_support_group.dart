import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_list_tile_external.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_notched_cupertino_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../../../logging/presentation/pages/cupertino/cupertino_style_logs_page.dart';

class CupertinoStyleHelpAndSupportGroup extends StatelessWidget {
  const CupertinoStyleHelpAndSupportGroup({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return CupertinoStyleListSection(
      headerText: LocaleKeys.help_and_support_title.tr(),
      children: [
        CupertinoStyleNotchedCupertinoListTile(
          leading: const FaIcon(
            FontAwesomeIcons.github,
            color: ThemeHelper.cupertinoListTileIconColor,
            size: 23,
          ),
          trailing: const CupertinoStyleListTileExternal(),
          titleText: LocaleKeys.wiki_title.tr(),
          onTap: () async {
            await launchUrlString(
              mode: LaunchMode.externalApplication,
              'https://github.com/Tautulli/Tautulli-Remote/wiki',
            );
          },
        ),
        CupertinoStyleNotchedCupertinoListTile(
          leading: const FaIcon(
            FontAwesomeIcons.discord,
            color: ThemeHelper.cupertinoListTileIconColor,
            size: 19.2,
          ),
          trailing: const CupertinoStyleListTileExternal(),
          titleText: LocaleKeys.discord_title.tr(),
          onTap: () async {
            await launchUrlString(
              mode: LaunchMode.externalApplication,
              'https://tautulli.com/discord.html',
            );
          },
        ),
        CupertinoStyleNotchedCupertinoListTile(
          leading: const FaIcon(
            FontAwesomeIcons.redditAlien,
            color: ThemeHelper.cupertinoListTileIconColor,
            size: 23,
          ),
          trailing: const CupertinoStyleListTileExternal(),
          titleText: LocaleKeys.reddit_title.tr(),
          onTap: () async {
            await launchUrlString(
              mode: LaunchMode.externalApplication,
              'https://www.reddit.com/r/Tautulli/',
            );
          },
        ),
        CupertinoStyleNotchedCupertinoListTile(
          leading: const FaIcon(
            FontAwesomeIcons.github,
            color: ThemeHelper.cupertinoListTileIconColor,
            size: 23,
          ),
          trailing: const CupertinoStyleListTileExternal(),
          titleText: LocaleKeys.bugs_and_feature_requests_title.tr(),
          onTap: () async {
            await launchUrlString(
              mode: LaunchMode.externalApplication,
              'https://github.com/Tautulli/Tautulli-Remote/issues',
            );
          },
        ),
        CupertinoStyleNotchedCupertinoListTile(
          leading: const Icon(
            CupertinoIcons.list_bullet,
            color: ThemeHelper.cupertinoListTileIconColor,
          ),
          trailing: const CupertinoListTileChevron(),
          titleText: LocaleKeys.logs_title.tr(),
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => CupertinoStyleLogsPage(
                previousPageTitle: LocaleKeys.settings_title.tr(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
