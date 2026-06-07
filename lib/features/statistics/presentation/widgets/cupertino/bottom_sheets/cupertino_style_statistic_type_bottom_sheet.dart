import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:tautulli_remote/core/helpers/theme_helper.dart';

import '../../../../../../core/types/tautulli_types.dart';
import '../../../../../../core/widgets/ios/cupertino_modal_popup_scaffold.dart';
import '../../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../../core/widgets/ios/ios_bottom_sheet_cancel_button.dart';
import '../../../../../../translations/locale_keys.g.dart';

class CupertinoStyleStatisticTypeBottomSheet extends StatelessWidget {
  final PlayMetricType initialValue;

  const CupertinoStyleStatisticTypeBottomSheet({
    super.key,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoModalPopupScaffold(
      //TODO: Needs translation string
      middleText: 'Statistic Type',
      leading: const IosBottomSheetCancelButton(),
      child: CustomCupertinoListSection(
        children: [
          CustomNotchedCupertinoListTile(
            onTap: () {
              Navigator.of(context).pop(PlayMetricType.plays);
            },
            leading: Icon(
              CupertinoIcons.number,
              color: ThemeHelper.cupertinoListTileIconColor(),
            ),
            titleText: LocaleKeys.play_count_title.tr(),
            trailing: initialValue == PlayMetricType.plays ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CustomNotchedCupertinoListTile(
            onTap: () {
              Navigator.of(context).pop(PlayMetricType.time);
            },
            leading: Icon(
              CupertinoIcons.clock_fill,
              color: ThemeHelper.cupertinoListTileIconColor(),
            ),
            titleText: LocaleKeys.play_time_title.tr(),
            trailing: initialValue == PlayMetricType.time ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
        ],
      ),
    );
  }
}
