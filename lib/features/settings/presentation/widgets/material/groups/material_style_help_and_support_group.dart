import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../../core/widgets/material/material_style_list_tile.dart';
import '../../../../../../core/widgets/material/material_style_list_tile_group.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../../../logging/presentation/pages/material/material_style_logging_page.dart';

class MaterialStyleHelpAndSupportGroup extends StatelessWidget {
  const MaterialStyleHelpAndSupportGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialStyleListTileGroup(
      heading: LocaleKeys.help_and_support_title.tr(),
      listTiles: [
        MaterialStyleListTile(
          leading: FaIcon(
            FontAwesomeIcons.github,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          title: LocaleKeys.wiki_title.tr(),
          onTap: () async {
            await launchUrlString(
              mode: LaunchMode.externalApplication,
              'https://github.com/Tautulli/Tautulli-Remote/wiki',
            );
          },
        ),
        MaterialStyleListTile(
          leading: FaIcon(
            FontAwesomeIcons.discord,
            size: 22,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          title: LocaleKeys.discord_title.tr(),
          onTap: () async {
            await launchUrlString(
              mode: LaunchMode.externalApplication,
              'https://tautulli.com/discord.html',
            );
          },
        ),
        MaterialStyleListTile(
          leading: FaIcon(
            FontAwesomeIcons.redditAlien,
            size: 28,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          title: LocaleKeys.reddit_title.tr(),
          onTap: () async {
            await launchUrlString(
              mode: LaunchMode.externalApplication,
              'https://www.reddit.com/r/Tautulli/',
            );
          },
        ),
        MaterialStyleListTile(
          leading: FaIcon(
            FontAwesomeIcons.github,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          title: LocaleKeys.bugs_and_feature_requests_title.tr(),
          onTap: () async {
            await launchUrlString(
              mode: LaunchMode.externalApplication,
              'https://github.com/Tautulli/Tautulli-Remote/issues',
            );
          },
        ),
        MaterialStyleListTile(
          leading: FaIcon(
            FontAwesomeIcons.list,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          title: LocaleKeys.tautulli_remote_logs_title.tr(),
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const MaterialStyleLoggingPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}
