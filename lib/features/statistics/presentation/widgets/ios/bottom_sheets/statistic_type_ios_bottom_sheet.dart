import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../core/types/tautulli_types.dart';
import '../../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../../core/widgets/ios/ios_bottom_sheet_cancel_button.dart';
import '../../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../../translations/locale_keys.g.dart';

class StatisticTypeIosBottomSheet extends StatelessWidget {
  final PlayMetricType initialValue;

  const StatisticTypeIosBottomSheet({
    super.key,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return PageScaffoldCupertino(
      showBackButton: false,
      //TODO: Needs translation string
      middle: const Text('Statistic Type'),
      leading: const IosBottomSheetCancelButton(),
      child: CustomCupertinoListSection(
        hasLeading: false,
        children: [
          CustomNotchedCupertinoListTile(
            onTap: () {
              Navigator.of(context).pop(PlayMetricType.plays);
            },
            titleText: LocaleKeys.play_count_title.tr(),
            trailing: initialValue == PlayMetricType.plays ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CustomNotchedCupertinoListTile(
            onTap: () {
              Navigator.of(context).pop(PlayMetricType.time);
            },
            titleText: LocaleKeys.play_time_title.tr(),
            trailing: initialValue == PlayMetricType.time ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
        ],
      ),
    );
  }
}
