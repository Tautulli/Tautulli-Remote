import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tautulli_remote/core/device_info/device_info.dart';
import 'package:tautulli_remote/dependency_injection.dart' as di;
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/package_information/package_information.dart';
import '../../../../../../core/widgets/ios/cupertino_list_tile_external.dart';
import '../../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';

class AboutIosGroup extends StatelessWidget {
  const AboutIosGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCupertinoListSection(
      headerText: LocaleKeys.about_title.tr(),
      children: [
        CustomNotchedCupertinoListTile(
          leading: Icon(
            CupertinoIcons.info_circle_fill,
            color: ThemeHelper.cupertinoListTileIconColor(),
          ),
          title: const Text('Tautulli Remote'),
          subtitle: Row(
            children: [
              FutureBuilder(
                future: PackageInformationImpl().version,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Text(snapshot.data.toString());
                  }
                  return const Text('');
                },
              ),
              FutureBuilder(
                future: PackageInformationImpl().buildNumber,
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
        CustomNotchedCupertinoListTile(
          leading: FaIcon(
            FontAwesomeIcons.fileInvoice,
            color: ThemeHelper.cupertinoListTileIconColor(),
            size: 23,
          ),
          trailing: const CupertinoListTileExternal(),
          title: const Text('License'),
          subtitle: const Text('GNU General Public License v3.0'),
          onTap: () async {
            await launchUrlString(
              mode: LaunchMode.externalApplication,
              'https://www.gnu.org/licenses/gpl-3.0.en.html',
            );
          },
        ),
        if (di.sl<DeviceInfo>().platform == 'ios')
          CustomNotchedCupertinoListTile(
            leading: FaIcon(
              FontAwesomeIcons.fileInvoice,
              color: ThemeHelper.cupertinoListTileIconColor(),
              size: 23,
            ),
            trailing: const CupertinoListTileExternal(),
            title: const Text(
              LocaleKeys.terms_of_use_title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ).tr(),
            onTap: () async {
              await launchUrlString(
                mode: LaunchMode.externalApplication,
                'https://tautulli.com/tautulli_remote_ios_terms_and_conditions',
              );
            },
          ),
        CustomNotchedCupertinoListTile(
          leading: FaIcon(
            FontAwesomeIcons.fileInvoice,
            color: ThemeHelper.cupertinoListTileIconColor(),
            size: 23,
          ),
          trailing: const CupertinoListTileExternal(),
          title: const Text(
            LocaleKeys.privacy_policy_title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ).tr(),
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
