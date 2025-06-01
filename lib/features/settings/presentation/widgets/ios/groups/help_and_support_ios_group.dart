import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../../core/widgets/ios/cupertino_list_tile_external.dart';
import '../../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../../../logging/presentation/pages/ios/logging_ios_page.dart';

class HelpAndSupportIosGroup extends StatelessWidget {
  const HelpAndSupportIosGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCupertinoListSection(
      headerText: LocaleKeys.help_and_support_title.tr(),
      children: [
        CupertinoListTile.notched(
          leading: const FaIcon(FontAwesomeIcons.github),
          trailing: const CupertinoListTileExternal(),
          title: const Text(LocaleKeys.wiki_title).tr(),
          onTap: () async {
            await launchUrlString(
              mode: LaunchMode.externalApplication,
              'https://github.com/Tautulli/Tautulli-Remote/wiki',
            );
          },
        ),
        CupertinoListTile.notched(
          leading: const FaIcon(FontAwesomeIcons.discord),
          trailing: const CupertinoListTileExternal(),
          title: const Text(LocaleKeys.discord_title).tr(),
          onTap: () async {
            await launchUrlString(
              mode: LaunchMode.externalApplication,
              'https://tautulli.com/discord.html',
            );
          },
        ),
        CupertinoListTile.notched(
          leading: const FaIcon(FontAwesomeIcons.redditAlien),
          trailing: const CupertinoListTileExternal(),
          title: const Text(LocaleKeys.reddit_title).tr(),
          onTap: () async {
            await launchUrlString(
              mode: LaunchMode.externalApplication,
              'https://www.reddit.com/r/Tautulli/',
            );
          },
        ),
        CupertinoListTile.notched(
          leading: const FaIcon(FontAwesomeIcons.github),
          trailing: const CupertinoListTileExternal(),
          title: const Text(LocaleKeys.bugs_and_feature_requests_title).tr(),
          onTap: () async {
            await launchUrlString(
              mode: LaunchMode.externalApplication,
              'https://github.com/Tautulli/Tautulli-Remote/issues',
            );
          },
        ),
        CupertinoListTile.notched(
          leading: const FaIcon(FontAwesomeIcons.list),
          trailing: const CupertinoListTileChevron(),
          title: const Text(LocaleKeys.tautulli_remote_logs_title).tr(),
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => const LoggingIosPage(),
            ),
          ),
        ),
      ],
    );
  }
}
