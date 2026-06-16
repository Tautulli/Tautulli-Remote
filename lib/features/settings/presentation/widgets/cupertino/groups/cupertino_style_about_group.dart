import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../../core/device_info/device_info.dart';
import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/package_information/package_information.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_list_tile_external.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_notched_cupertino_list_tile.dart';
import '../../../../../../dependency_injection.dart' as di;
import '../../../../../../translations/locale_keys.g.dart';

class CupertinoStyleAboutGroup extends StatelessWidget {
  const CupertinoStyleAboutGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoStyleListSection(
      headerText: LocaleKeys.about_title.tr(),
      children: [
        CupertinoStyleNotchedCupertinoListTile(
          leading: Icon(
            CupertinoIcons.info_circle_fill,
            color: ThemeHelper.cupertinoListTileIconColor(),
          ),
          titleText: 'Tautulli Remote',
          subtitleWidget: Row(
            children: [
              FutureBuilder(
                future: di.sl<PackageInformation>().version,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Text(snapshot.data.toString());
                  }
                  return const Text('');
                },
              ),
              FutureBuilder(
                future: di.sl<PackageInformation>().buildNumber,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Text(' (${snapshot.data.toString()})');
                  }
                  return const Text('');
                },
              ),
            ],
          ),
        ),
        CupertinoStyleNotchedCupertinoListTile(
          leading: FaIcon(
            FontAwesomeIcons.fileInvoice,
            color: ThemeHelper.cupertinoListTileIconColor(),
            size: 23,
          ),
          trailing: const CupertinoStyleListTileExternal(),
          titleText: 'License',
          subtitleText: 'GNU General Public License v3.0',
          onTap: () async {
            await launchUrlString(
              mode: LaunchMode.externalApplication,
              'https://www.gnu.org/licenses/gpl-3.0.en.html',
            );
          },
        ),
        if (di.sl<DeviceInfo>().platform == 'ios')
          CupertinoStyleNotchedCupertinoListTile(
            leading: FaIcon(
              FontAwesomeIcons.fileInvoice,
              color: ThemeHelper.cupertinoListTileIconColor(),
              size: 23,
            ),
            trailing: const CupertinoStyleListTileExternal(),
            titleText: LocaleKeys.terms_of_use_title.tr(),
            onTap: () async {
              await launchUrlString(
                mode: LaunchMode.externalApplication,
                'https://tautulli.com/tautulli_remote_ios_terms_and_conditions',
              );
            },
          ),
        CupertinoStyleNotchedCupertinoListTile(
          leading: FaIcon(
            FontAwesomeIcons.fileInvoice,
            color: ThemeHelper.cupertinoListTileIconColor(),
            size: 23,
          ),
          trailing: const CupertinoStyleListTileExternal(),
          titleText: LocaleKeys.privacy_policy_title.tr(),
          onTap: () async {
            await launchUrlString(
              mode: LaunchMode.externalApplication,
              'https://tautulli.com/tautulli_remote_privacy',
            );
          },
        ),
      ],
    );
  }
}
