import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../settings/presentation/widgets/settings_group.dart';
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
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
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
                    SizedBox(height: 8),
                    Text(
                      'Your contributions help improve Tautulli Remote and make it accessible to more of the community.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              indent: 32,
              endIndent: 32,
            ),
            SettingsGroup(
              settingsListTiles: [
                SettingsListTile(
                  leading: WebsafeSvg.asset(
                    'assets/logos/weblate.svg',
                    color: TautulliColorPalette.notWhite,
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
