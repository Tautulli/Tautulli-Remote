import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/types/tautulli_types.dart';
import '../../../../../../core/widgets/cupertino/buttons/cupertino_style_bottom_sheet_cancel_button.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_modal_popup_scaffold.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_notched_cupertino_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';

class CupertinoStyleStatisticTypeBottomSheet extends StatelessWidget {
  final PlayMetricType initialValue;

  const CupertinoStyleStatisticTypeBottomSheet({
    super.key,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoStyleModalPopupScaffold(
      middleText: LocaleKeys.statistic_type_title.tr(),
      leading: const CupertinoStyleBottomSheetCancelButton(),
      child: CupertinoStyleListSection(
        children: [
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () {
              Navigator.of(context).pop(PlayMetricType.plays);
            },
            leading: const Icon(
              CupertinoIcons.number,
              color: ThemeHelper.cupertinoListTileIconColor,
            ),
            titleText: LocaleKeys.play_count_title.tr(),
            trailing: initialValue == PlayMetricType.plays ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () {
              Navigator.of(context).pop(PlayMetricType.time);
            },
            leading: const Icon(
              CupertinoIcons.clock_fill,
              color: ThemeHelper.cupertinoListTileIconColor,
            ),
            titleText: LocaleKeys.play_time_title.tr(),
            trailing: initialValue == PlayMetricType.time ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
        ],
      ),
    );
  }
}
