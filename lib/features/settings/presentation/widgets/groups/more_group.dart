import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../../core/package_information/package_information.dart';
import '../../../../../core/widgets/custom_list_tile.dart';
import '../../../../../core/widgets/list_tile_group.dart';
import '../../../../../translations/locale_keys.g.dart';

class MoreGroup extends StatelessWidget {
  const MoreGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTileGroup(
      heading: LocaleKeys.more_title.tr(),
      listTiles: [
        CustomListTile(
          leading: WebsafeSvg.asset(
            'assets/logos/onesignal.svg',
            color: Theme.of(context).colorScheme.tertiary,
            height: 35,
          ),
          title: LocaleKeys.onesignal_data_privacy_title.tr(),
          onTap: () {
            Navigator.of(context).pushNamed('/onesignal_privacy');
          },
        ),
        CustomListTile(
          leading: const FaIcon(FontAwesomeIcons.clipboardList),
          title: LocaleKeys.changelog_title.tr(),
          onTap: () {
            Navigator.of(context).pushNamed('/changelog');
          },
        ),
        CustomListTile(
          leading: const FaIcon(FontAwesomeIcons.globe),
          title: LocaleKeys.help_translate_title.tr(),
          onTap: () {
            Navigator.of(context).pushNamed('/help_translate');
          },
        ),
        CustomListTile(
          leading: const FaIcon(FontAwesomeIcons.infoCircle),
          title: LocaleKeys.about_title.tr(),
          onTap: () async {
            showAboutDialog(
              context: context,
              applicationIcon: SizedBox(
                height: 50,
                child: Image.asset('assets/logos/logo.png'),
              ),
              applicationName: 'Tautulli Remote',
              applicationVersion: await PackageInformationImpl().version,
              applicationLegalese: LocaleKeys.about_legalese.tr(),
            );
          },
        ),
      ],
    );
  }
}
