import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../../core/package_information/package_information.dart';
import '../../../../../../core/widgets/ios/cupertino_list_tile_external.dart';
import '../../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../../translations/locale_keys.g.dart';

class AboutIosGroup extends StatelessWidget {
  const AboutIosGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCupertinoListSection(
      headerText: LocaleKeys.about_title.tr(),
      children: [
        CupertinoListTile.notched(
          leading: const FaIcon(FontAwesomeIcons.circleInfo),
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
        CupertinoListTile.notched(
          leading: const FaIcon(FontAwesomeIcons.fileInvoice),
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
      ],
    );
  }
}
