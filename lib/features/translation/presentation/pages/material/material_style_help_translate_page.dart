import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/widgets/material/material_style_list_tile.dart';
import '../../../../../core/widgets/material/material_style_list_tile_external.dart';
import '../../../../../core/widgets/material/material_style_list_tile_group.dart';
import '../../../../../core/widgets/material/material_style_page_body.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../widgets/material/material_style_help_translate_heading_card.dart';

class MaterialStyleHelpTranslatePage extends StatelessWidget {
  const MaterialStyleHelpTranslatePage({super.key});

  static const routeName = '/help_translate';

  @override
  Widget build(BuildContext context) {
    return const MaterialStyleHelpTranslateView();
  }
}

class MaterialStyleHelpTranslateView extends StatelessWidget {
  const MaterialStyleHelpTranslateView({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(LocaleKeys.help_translate_title).tr(),
      ),
      body: MaterialStylePageBody(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            const MaterialStyleHelpTranslateHeadingCard(),
            MaterialStyleListTileGroup(
              listTiles: [
                MaterialStyleListTile(
                  leading: SvgPicture.asset(
                    'assets/logos/weblate.svg',
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onSurface,
                      BlendMode.srcIn,
                    ),
                    height: 30,
                    width: 30,
                  ),
                  title: LocaleKeys.translate_tautulli_remote_title.tr(),
                  trailing: const MaterialStyleListTileExternal(),
                  onTap: () async {
                    await launchUrlString(
                      mode: LaunchMode.externalApplication,
                      'https://hosted.weblate.org/engage/tautulli-remote/',
                    );
                  },
                ),
                MaterialStyleListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.github,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  title: LocaleKeys.request_a_new_language_title.tr(),
                  trailing: const MaterialStyleListTileExternal(),
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
