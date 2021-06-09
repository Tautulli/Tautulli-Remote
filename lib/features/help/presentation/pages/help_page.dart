import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/list_header.dart';
import '../../../../translations/locale_keys.g.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key key}) : super(key: key);

  static const routeName = '/help';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text(LocaleKeys.help_page_title).tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ListView(
          children: [
            ListHeader(headingText: LocaleKeys.help_help_topics_heading.tr()),
            ListTile(
              title: const Text('Secondary Connection Address'),
              trailing: const FaIcon(
                FontAwesomeIcons.externalLinkAlt,
                color: TautulliColorPalette.smoke,
                size: 20,
              ),
              onTap: () async {
                await launch(
                  'https://github.com/Tautulli/Tautulli-Remote/wiki/Settings#secondary_connection',
                );
              },
            ),
            ListTile(
              title: const Text('Using Basic Authentication'),
              trailing: const FaIcon(
                FontAwesomeIcons.externalLinkAlt,
                color: TautulliColorPalette.smoke,
                size: 20,
              ),
              onTap: () async {
                await launch(
                  'https://github.com/Tautulli/Tautulli-Remote/wiki/Settings#basic_authentication',
                );
              },
            ),
            ListTile(
              title: const Text('Terminating a Stream'),
              trailing: const FaIcon(
                FontAwesomeIcons.externalLinkAlt,
                color: TautulliColorPalette.smoke,
                size: 20,
              ),
              onTap: () async {
                await launch(
                  'https://github.com/Tautulli/Tautulli-Remote/wiki/Features#terminating_stream',
                );
              },
            ),
            const SizedBox(height: 15),
            ListHeader(headingText: LocaleKeys.help_support_heading.tr()),
            ListTile(
              title: const Text('Wiki'),
              trailing: const FaIcon(
                FontAwesomeIcons.externalLinkAlt,
                color: TautulliColorPalette.smoke,
                size: 20,
              ),
              onTap: () async {
                await launch(
                  'https://github.com/Tautulli/Tautulli-Remote/wiki',
                );
              },
            ),
            ListTile(
              title: const Text('Discord'),
              trailing: const FaIcon(
                FontAwesomeIcons.externalLinkAlt,
                color: TautulliColorPalette.smoke,
                size: 20,
              ),
              onTap: () async {
                await launch('https://tautulli.com/discord.html');
              },
            ),
            ListTile(
              title: const Text('Reddit'),
              trailing: const FaIcon(
                FontAwesomeIcons.externalLinkAlt,
                color: TautulliColorPalette.smoke,
                size: 20,
              ),
              onTap: () async {
                await launch('https://www.reddit.com/r/Tautulli/');
              },
            ),
            const SizedBox(height: 15),
            ListHeader(headingText: LocaleKeys.help_bugs_features_heading.tr()),
            ListTile(
              title: const Text('GitHub'),
              trailing: const FaIcon(
                FontAwesomeIcons.externalLinkAlt,
                color: TautulliColorPalette.smoke,
                size: 20,
              ),
              onTap: () async {
                await launch(
                    'https://github.com/Tautulli/Tautulli-Remote/issues');
              },
            ),
            const SizedBox(height: 15),
            ListHeader(headingText: LocaleKeys.help_logs_heading.tr()),
            ListTile(
              title: const Text(LocaleKeys.help_tautulli_remote_logs).tr(),
              trailing: const FaIcon(
                FontAwesomeIcons.angleRight,
                color: TautulliColorPalette.smoke,
                size: 20,
              ),
              onTap: () => Navigator.of(context).pushNamed('/logs'),
            ),
          ],
        ),
      ),
    );
  }
}
