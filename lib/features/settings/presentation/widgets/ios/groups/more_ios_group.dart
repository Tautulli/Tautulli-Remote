import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../../translations/locale_keys.g.dart';

class MoreIosGroup extends StatelessWidget {
  const MoreIosGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCupertinoListSection(
      headerText: LocaleKeys.more_title.tr(),
      children: [
        CupertinoListTile.notched(
          leading: WebsafeSvg.asset(
            'assets/logos/onesignal.svg',
            colorFilter: ColorFilter.mode(
              CupertinoTheme.of(context).primaryColor,
              BlendMode.srcIn,
            ),
          ),
          trailing: const CupertinoListTileChevron(),
          title: const Text(LocaleKeys.onesignal_data_privacy_title).tr(),
          // onTap: () {
          //   Navigator.of(context).pushNamed('/onesignal_privacy');
          // },
        ),
        CupertinoListTile.notched(
          leading: const FaIcon(FontAwesomeIcons.clipboardList),
          trailing: const CupertinoListTileChevron(),
          title: const Text(LocaleKeys.changelog_title).tr(),
          // onTap: () {
          //   Navigator.of(context).pushNamed('/changelog');
          // },
        ),
        CupertinoListTile.notched(
          leading: const FaIcon(FontAwesomeIcons.globe),
          trailing: const CupertinoListTileChevron(),
          title: const Text(LocaleKeys.help_translate_title).tr(),
          // onTap: () {
          //   Navigator.of(context).pushNamed('/help_translate');
          // },
        ),
        CupertinoListTile.notched(
          leading: const FaIcon(FontAwesomeIcons.faucet),
          trailing: const CupertinoListTileChevron(),
          title: const Text(LocaleKeys.data_dump_title).tr(),
          // onTap: () async {
          //   await Navigator.of(context).push(
          //     MaterialPageRoute(
          //       fullscreenDialog: true,
          //       builder: (context) => const DataDumpPage(),
          //     ),
          //   );
          // },
        ),
      ],
    );
  }
}
