import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../../../changelog/presentation/pages/ios/changelog_ios_page.dart';
import '../../../../../onesignal/presentation/pages/ios/onesignal_data_privacy_ios_page.dart';
import '../../../../../translation/presentation/pages/ios/help_translate_ios_page.dart';
import '../../../pages/ios/data_dump_ios_page.dart';

class MoreIosGroup extends StatelessWidget {
  const MoreIosGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCupertinoListSection(
      headerText: LocaleKeys.more_title.tr(),
      children: [
        CustomNotchedCupertinoListTile(
          leading: WebsafeSvg.asset(
            'assets/logos/onesignal.svg',
            colorFilter: ColorFilter.mode(
              ThemeHelper.cupertinoListTileIconColor(),
              BlendMode.srcIn,
            ),
          ),
          trailing: const CupertinoListTileChevron(),
          title: const Text(
            LocaleKeys.onesignal_data_privacy_title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ).tr(),
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => OneSignalDataPrivacyIosPage(
                previousPageTitle: LocaleKeys.settings_title.tr(),
              ),
            ),
          ),
        ),
        CustomNotchedCupertinoListTile(
          leading: Icon(
            CupertinoIcons.square_list_fill,
            color: ThemeHelper.cupertinoListTileIconColor(),
          ),
          trailing: const CupertinoListTileChevron(),
          title: const Text(
            LocaleKeys.changelog_title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ).tr(),
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => ChangelogIosPage(
                previousPageTitle: LocaleKeys.settings_title.tr(),
              ),
            ),
          ),
        ),
        CustomNotchedCupertinoListTile(
          leading: FaIcon(
            FontAwesomeIcons.globe,
            color: ThemeHelper.cupertinoListTileIconColor(),
            size: 23,
          ),
          trailing: const CupertinoListTileChevron(),
          title: const Text(
            LocaleKeys.help_translate_title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ).tr(),
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => HelpTranslateIosPage(
                previousPageTitle: LocaleKeys.settings_title.tr(),
              ),
            ),
          ),
        ),
        CustomNotchedCupertinoListTile(
          leading: FaIcon(
            FontAwesomeIcons.faucet,
            color: ThemeHelper.cupertinoListTileIconColor(),
            size: 23,
          ),
          trailing: const CupertinoListTileChevron(),
          title: const Text(
            LocaleKeys.data_dump_title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ).tr(),
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => DataDumpIosPage(
                previousPageTitle: LocaleKeys.settings_title.tr(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
