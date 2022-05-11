import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../core/widgets/custom_list_tile.dart';
import '../../../../../core/widgets/list_tile_group.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../logging/presentation/pages/logging_page.dart';

class HelpAndSupportGroup extends StatelessWidget {
  const HelpAndSupportGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTileGroup(
      heading: LocaleKeys.help_and_support_title.tr(),
      listTiles: [
        CustomListTile(
          leading: const FaIcon(FontAwesomeIcons.github),
          title: LocaleKeys.wiki_title.tr(),
          onTap: () async {
            await launchUrlString(
                'https://github.com/Tautulli/Tautulli-Remote/wiki');
          },
        ),
        CustomListTile(
          leading: const FaIcon(
            FontAwesomeIcons.discord,
            size: 22,
          ),
          title: LocaleKeys.discord_title.tr(),
          onTap: () async {
            await launchUrlString('https://tautulli.com/discord.html');
          },
        ),
        CustomListTile(
          leading: const FaIcon(
            FontAwesomeIcons.redditAlien,
            size: 28,
          ),
          title: LocaleKeys.reddit_title.tr(),
          onTap: () async {
            await launchUrlString('https://www.reddit.com/r/Tautulli/');
          },
        ),
        CustomListTile(
          leading: const FaIcon(FontAwesomeIcons.github),
          title: LocaleKeys.bugs_and_feature_requests_title.tr(),
          onTap: () async {
            await launchUrlString(
                'https://github.com/Tautulli/Tautulli-Remote/issues');
          },
        ),
        CustomListTile(
          leading: const FaIcon(FontAwesomeIcons.list),
          title: LocaleKeys.tautulli_remote_logs_title.tr(),
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const LoggingPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}
