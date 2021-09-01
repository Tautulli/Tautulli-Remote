// @dart=2.9

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../translations/locale_keys.g.dart';

class TranslatePage extends StatelessWidget {
  const TranslatePage({Key key}) : super(key: key);

  static const routeName = '/translate';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text(LocaleKeys.translate_page_title).tr(),
      ),
      body: Column(
        children: [
          const Divider(
            indent: 50,
            endIndent: 50,
            height: 50,
            color: PlexColorPalette.gamboge,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                const Text(
                  LocaleKeys.translate_text_1,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ).tr(),
                const SizedBox(height: 12),
                const Text(
                  LocaleKeys.translate_text_2,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ).tr(),
              ],
            ),
          ),
          const Divider(
            indent: 50,
            endIndent: 50,
            height: 50,
            color: PlexColorPalette.gamboge,
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: const Text(LocaleKeys.translate_help_translate).tr(),
                  trailing: const FaIcon(
                    FontAwesomeIcons.externalLinkAlt,
                    color: TautulliColorPalette.smoke,
                    size: 20,
                  ),
                  onTap: () async {
                    await launch(
                      'https://hosted.weblate.org/engage/tautulli-remote/',
                    );
                  },
                ),
                ListTile(
                  title: const Text(LocaleKeys.translate_request_language).tr(),
                  trailing: const FaIcon(
                    FontAwesomeIcons.externalLinkAlt,
                    color: TautulliColorPalette.smoke,
                    size: 20,
                  ),
                  onTap: () async {
                    await launch(
                      'https://github.com/Tautulli/Tautulli-Remote/issues/new/choose',
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
