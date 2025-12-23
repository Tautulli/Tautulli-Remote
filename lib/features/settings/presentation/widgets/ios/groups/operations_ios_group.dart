import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../dialogs/clear_app_image_cache_ios_dialog.dart';

class OperationsIosGroup extends StatelessWidget {
  const OperationsIosGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCupertinoListSection(
      headerText: LocaleKeys.operations_title.tr(),
      children: [
        CustomNotchedCupertinoListTile(
          leading: FaIcon(
            FontAwesomeIcons.eraser,
            color: ThemeHelper.cupertinoListTileIconColor(),
            size: 21.3,
          ),
          trailing: const CupertinoListTileChevron(),
          titleText: LocaleKeys.clear_app_image_cache_title.tr(),
          subtitleText: LocaleKeys.clear_app_image_cache_subtitle.tr(),
          onTap: () async {
            final bool cleared = await showCupertinoDialog(
              context: context,
              builder: (context) => const ClearAppImageCacheIosDialog(),
            );

            if (cleared) {
              Fluttertoast.showToast(
                toastLength: Toast.LENGTH_SHORT,
                msg: LocaleKeys.clear_app_image_cache_success_snackbar_message.tr(),
              );
            }
          },
        ),
      ],
    );
  }
}
