import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_notched_cupertino_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../../../changelog/presentation/pages/cupertino/cupertino_style_changelog_page.dart';
import '../../../../../onesignal/presentation/pages/cupertino/cupertino_style_onesignal_data_privacy_page.dart';
import '../../../../../translation/presentation/pages/cupertino/cupertino_style_help_translate_page.dart';
import '../../../pages/cupertino/cupertino_style_data_dump_page.dart';

class CupertinoStyleMoreGroup extends StatelessWidget {
  const CupertinoStyleMoreGroup({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return CupertinoStyleListSection(
      headerText: LocaleKeys.more_title.tr(),
      children: [
        CupertinoStyleNotchedCupertinoListTile(
          leading: SvgPicture.asset(
            'assets/logos/onesignal.svg',
            colorFilter: const ColorFilter.mode(
              ThemeHelper.cupertinoListTileIconColor,
              BlendMode.srcIn,
            ),
          ),
          trailing: const CupertinoListTileChevron(),
          titleText: LocaleKeys.onesignal_data_privacy_title.tr(),
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => CupertinoStyleOnesignalDataPrivacyPage(
                previousPageTitle: LocaleKeys.settings_title.tr(),
              ),
            ),
          ),
        ),
        CupertinoStyleNotchedCupertinoListTile(
          leading: const Icon(
            CupertinoIcons.square_list_fill,
            color: ThemeHelper.cupertinoListTileIconColor,
          ),
          trailing: const CupertinoListTileChevron(),
          titleText: LocaleKeys.changelog_title.tr(),
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => CupertinoStyleChangelogPage(
                previousPageTitle: LocaleKeys.settings_title.tr(),
              ),
            ),
          ),
        ),
        CupertinoStyleNotchedCupertinoListTile(
          leading: const FaIcon(
            FontAwesomeIcons.globe,
            color: ThemeHelper.cupertinoListTileIconColor,
            size: 23,
          ),
          trailing: const CupertinoListTileChevron(),
          titleText: LocaleKeys.help_translate_title.tr(),
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => CupertinoStyleHelpTranslatePage(
                previousPageTitle: LocaleKeys.settings_title.tr(),
              ),
            ),
          ),
        ),
        CupertinoStyleNotchedCupertinoListTile(
          leading: const FaIcon(
            FontAwesomeIcons.faucet,
            color: ThemeHelper.cupertinoListTileIconColor,
            size: 23,
          ),
          trailing: const CupertinoListTileChevron(),
          titleText: LocaleKeys.data_dump_title.tr(),
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => CupertinoStyleDataDumpPage(
                previousPageTitle: LocaleKeys.settings_title.tr(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
