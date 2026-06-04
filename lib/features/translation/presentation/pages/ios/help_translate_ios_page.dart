import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/widgets/ios/cupertino_list_tile_external.dart';
import '../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../widgets/ios/help_translate_heading_ios_card.dart';

class HelpTranslateIosPage extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const HelpTranslateIosPage({
    super.key,
    this.showBackButton = true,
    this.previousPageTitle,
  });

  static const routeName = '/help_translate';

  @override
  Widget build(BuildContext context) {
    return HelpTranslateIosView(
      showBackButton: showBackButton,
      previousPageTitle: previousPageTitle,
    );
  }
}

class HelpTranslateIosView extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const HelpTranslateIosView({
    super.key,
    required this.showBackButton,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return PageScaffoldCupertino(
      showBackButton: showBackButton,
      previousPageTitle: previousPageTitle,
      middle: const Text(LocaleKeys.help_translate_title).tr(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const HelpTranslateHeadingIosCard(),
            CustomCupertinoListSection(
              margin: const EdgeInsets.fromLTRB(8, 20, 8, 8),
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
                  titleText: LocaleKeys.translate_tautulli_remote_title.tr(),
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
                  titleText: LocaleKeys.request_a_new_language_title.tr(),
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
