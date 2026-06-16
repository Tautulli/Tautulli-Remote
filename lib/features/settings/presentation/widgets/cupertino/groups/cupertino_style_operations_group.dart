import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_notched_cupertino_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../dialogs/cupertino_style_clear_app_image_cache_dialog.dart';

class CupertinoStyleOperationsGroup extends StatelessWidget {
  const CupertinoStyleOperationsGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoStyleListSection(
      headerText: LocaleKeys.operations_title.tr(),
      children: [
        CupertinoStyleNotchedCupertinoListTile(
          leading: const FaIcon(
            FontAwesomeIcons.eraser,
            color: ThemeHelper.cupertinoListTileIconColor,
            size: 21.3,
          ),
          trailing: const CupertinoListTileChevron(),
          titleText: LocaleKeys.clear_app_image_cache_title.tr(),
          subtitleText: LocaleKeys.clear_app_image_cache_subtitle.tr(),
          onTap: () async {
            final bool cleared = await showCupertinoDialog(
              context: context,
              builder: (context) => const CupertinoStyleClearAppImageCacheDialog(),
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
