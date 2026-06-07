import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/widgets/ios/cupertino_modal_popup_scaffold.dart';
import '../../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../../core/widgets/ios/ios_bottom_sheet_cancel_button.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class CupertinoStyleActivityRefreshRateBottomSheet extends StatelessWidget {
  final int initialValue;

  const CupertinoStyleActivityRefreshRateBottomSheet({
    super.key,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    void refreshValueChanged(int value) {
      context.read<SettingsBloc>().add(
        SettingsUpdateRefreshRate(value),
      );
      Navigator.of(context).pop();
    }

    return CupertinoModalPopupScaffold(
      middleText: LocaleKeys.activity_refresh_rate_title.tr(),
      leading: const IosBottomSheetCancelButton(),
      child: CustomCupertinoListSection(
        hasLeading: false,
        children: [
          CustomNotchedCupertinoListTile(
            onTap: () {
              refreshValueChanged(5);
            },
            titleText: '5 ${LocaleKeys.sec.tr()} - ${LocaleKeys.faster_title.tr()}',

            trailing: initialValue == 5 ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CustomNotchedCupertinoListTile(
            onTap: () {
              refreshValueChanged(7);
            },
            titleText: '7 ${LocaleKeys.sec.tr()} - ${LocaleKeys.fast_title.tr()}',

            trailing: initialValue == 7 ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CustomNotchedCupertinoListTile(
            onTap: () {
              refreshValueChanged(10);
            },
            titleText: '10 ${LocaleKeys.sec.tr()} - ${LocaleKeys.normal_title.tr()}',

            trailing: initialValue == 10 ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CustomNotchedCupertinoListTile(
            onTap: () {
              refreshValueChanged(15);
            },
            titleText: '15 ${LocaleKeys.sec.tr()} - ${LocaleKeys.slow_title.tr()}',

            trailing: initialValue == 15 ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CustomNotchedCupertinoListTile(
            onTap: () {
              refreshValueChanged(20);
            },
            titleText: '20 ${LocaleKeys.sec.tr()} - ${LocaleKeys.slower_title.tr()}',

            trailing: initialValue == 20 ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CustomNotchedCupertinoListTile(
            onTap: () {
              refreshValueChanged(0);
            },
            titleText: LocaleKeys.disabled_title.tr(),
            trailing: initialValue == 0 ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
        ],
      ),
    );
  }
}
