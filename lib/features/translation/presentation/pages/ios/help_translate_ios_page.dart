import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../../core/widgets/ios/cupertino_list_tile_external.dart';
import '../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../widgets/ios/help_translate_heading_ios_card.dart';

class HelpTranslateIosPage extends StatelessWidget {
  const HelpTranslateIosPage({super.key});

  static const routeName = '/help_translate';

  @override
  Widget build(BuildContext context) {
    return const HelpTranslateIosView();
  }
}

class HelpTranslateIosView extends StatelessWidget {
  const HelpTranslateIosView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageScaffoldCupertino(
      middle: const Text(LocaleKeys.help_translate_title).tr(),
      leading: CupertinoNavigationBarBackButton(
        //TODO: Eventually remove workaround for https://github.com/flutter/flutter/issues/89888
        onPressed: () => Navigator.of(context).pop(),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const HelpTranslateHeadingIosCard(),
            CustomCupertinoListSection(
              children: [
                CupertinoListTile.notched(
                  leading: WebsafeSvg.asset(
                    'assets/logos/weblate.svg',
                    colorFilter: ColorFilter.mode(
                      CupertinoTheme.of(context).primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  trailing: const CupertinoListTileExternal(),
                  title: const Text(LocaleKeys.translate_tautulli_remote_title).tr(),
                  onTap: () async {
                    await launchUrlString(
                      mode: LaunchMode.externalApplication,
                      'https://hosted.weblate.org/engage/tautulli-remote/',
                    );
                  },
                ),
                CupertinoListTile.notched(
                  leading: const FaIcon(FontAwesomeIcons.github),
                  trailing: const CupertinoListTileExternal(),
                  title: const Text(LocaleKeys.request_a_new_language_title).tr(),
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
