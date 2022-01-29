import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../core/widgets/list_tile_group.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../settings/presentation/widgets/settings_list_tile.dart';

class HelpTranslatePage extends StatelessWidget {
  const HelpTranslatePage({Key? key}) : super(key: key);

  static const routeName = '/help_translate';

  @override
  Widget build(BuildContext context) {
    return const HelpTranslateView();
  }
}

class HelpTranslateView extends StatelessWidget {
  const HelpTranslateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Translate'),
      ),
      body: PageBody(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Thank you for helping to translate Tautulli Remote!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Gap(8),
                    Text(
                      'Your contributions help improve Tautulli Remote and make it accessible to more of the community.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const Gap(4),
            const Divider(
              indent: 32,
              endIndent: 32,
            ),
            const Gap(4),
            ListTileGroup(
              listTiles: [
                SettingsListTile(
                  leading: WebsafeSvg.asset(
                    'assets/logos/weblate.svg',
                    color: Theme.of(context).colorScheme.secondaryVariant,
                    height: 35,
                    width: 35,
                  ),
                  title: 'Translate Tautulli Remote',
                  onTap: () async {
                    await launch(
                        'https://hosted.weblate.org/engage/tautulli-remote/');
                  },
                ),
                SettingsListTile(
                  leading: const FaIcon(FontAwesomeIcons.github),
                  title: 'Request a new language',
                  onTap: () async {
                    await launch(
                        'https://github.com/Tautulli/Tautulli-Remote/issues/new/choose');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
