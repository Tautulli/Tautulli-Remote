import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../core/widgets/custom_list_tile.dart';
import '../../../../core/widgets/list_tile_group.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../translations/locale_keys.g.dart';
import '../widgets/help_translate_heading_card.dart';

class HelpTranslatePage extends StatelessWidget {
  const HelpTranslatePage({super.key});

  static const routeName = '/help_translate';

  @override
  Widget build(BuildContext context) {
    return const HelpTranslateView();
  }
}

class HelpTranslateView extends StatelessWidget {
  const HelpTranslateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(LocaleKeys.help_translate_title).tr(),
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
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onSurface,
                      BlendMode.srcIn,
                    ),
                    height: 30,
                    width: 30,
                  ),
                  title: LocaleKeys.translate_tautulli_remote_title.tr(),
                  onTap: () async {
                    await launchUrlString(
                      mode: LaunchMode.externalApplication,
                      'https://hosted.weblate.org/engage/tautulli-remote/',
                    );
                  },
                ),
                CustomListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.github,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  title: LocaleKeys.request_a_new_language_title.tr(),
                  onTap: () async {
                    await launchUrlString(
                      mode: LaunchMode.externalApplication,
                      'https://github.com/Tautulli/Tautulli-Remote/issues/new/choose',
                    );
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
