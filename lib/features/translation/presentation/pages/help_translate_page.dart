import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../core/widgets/custom_list_tile.dart';
import '../../../../core/widgets/list_tile_group.dart';
import '../../../../core/widgets/page_body.dart';
import '../widgets/help_translate_heading_card.dart';

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
            const HelpTranslateHeadingCard(),
            ListTileGroup(
              listTiles: [
                CustomListTile(
                  leading: WebsafeSvg.asset(
                    'assets/logos/weblate.svg',
                    color: Theme.of(context).colorScheme.tertiary,
                    height: 35,
                    width: 35,
                  ),
                  title: 'Translate Tautulli Remote',
                  onTap: () async {
                    await launch(
                        'https://hosted.weblate.org/engage/tautulli-remote/');
                  },
                ),
                CustomListTile(
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
