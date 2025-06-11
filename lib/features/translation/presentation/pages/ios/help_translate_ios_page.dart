import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/widgets/ios/cupertino_list_tile_external.dart';
import '../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../core/widgets/ios/custom_cupertino_navigation_bar_back_button.dart';
import '../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../widgets/ios/help_translate_heading_ios_card.dart';

class HelpTranslateIosPage extends StatelessWidget {
  final String? previousPageTitle;

  const HelpTranslateIosPage({
    super.key,
    this.previousPageTitle,
  });

  static const routeName = '/help_translate';

  @override
  Widget build(BuildContext context) {
    return HelpTranslateIosView(
      previousPageTitle: previousPageTitle,
    );
  }
}

class HelpTranslateIosView extends StatelessWidget {
  final String? previousPageTitle;

  const HelpTranslateIosView({
    super.key,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return PageScaffoldCupertino(
      middle: const Text(LocaleKeys.help_translate_title).tr(),
      leading: CustomCupertinoNavigationBarBackButton(
        previousPageTitle: previousPageTitle,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const HelpTranslateHeadingIosCard(),
            CustomCupertinoListSection(
              children: [
                CustomNotchedCupertinoListTile(
                  leading: WebsafeSvg.asset(
                    'assets/logos/weblate.svg',
                    colorFilter: ColorFilter.mode(
                      ThemeHelper.cupertinoListTileIconColor(),
                      BlendMode.srcIn,
                    ),
                  ),
                  trailing: const CupertinoListTileExternal(),
                  title: const Text(
                    LocaleKeys.translate_tautulli_remote_title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ).tr(),
                  onTap: () async {
                    await launchUrlString(
                      mode: LaunchMode.externalApplication,
                      'https://hosted.weblate.org/engage/tautulli-remote/',
                    );
                  },
                ),
                CustomNotchedCupertinoListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.github,
                    color: ThemeHelper.cupertinoListTileIconColor(),
                    size: 23,
                  ),
                  trailing: const CupertinoListTileExternal(),
                  title: const Text(
                    LocaleKeys.request_a_new_language_title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ).tr(),
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
