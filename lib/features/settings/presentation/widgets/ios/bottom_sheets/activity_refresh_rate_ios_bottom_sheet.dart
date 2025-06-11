import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../../core/widgets/ios/ios_bottom_sheet_cancel_button.dart';
import '../../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class ActivityRefreshRateIosBottomSheet extends StatelessWidget {
  final int initialValue;

  const ActivityRefreshRateIosBottomSheet({
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

    return PageScaffoldCupertino(
      middle: const Text(LocaleKeys.activity_refresh_rate_title).tr(),
      leading: const IosBottomSheetCancelButton(),
      child: CustomCupertinoListSection(
        hasLeading: false,
        children: [
          CustomNotchedCupertinoListTile(
            onTap: () {
              refreshValueChanged(5);
            },
            title: Text(
              '5 ${LocaleKeys.sec.tr()} - ${LocaleKeys.faster_title.tr()}',
            ),
            trailing: initialValue == 5 ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CustomNotchedCupertinoListTile(
            onTap: () {
              refreshValueChanged(7);
            },
            title: Text(
              '7 ${LocaleKeys.sec.tr()} - ${LocaleKeys.fast_title.tr()}',
            ),
            trailing: initialValue == 7 ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CustomNotchedCupertinoListTile(
            onTap: () {
              refreshValueChanged(10);
            },
            title: Text(
              '10 ${LocaleKeys.sec.tr()} - ${LocaleKeys.normal_title.tr()}',
            ),
            trailing: initialValue == 10 ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CustomNotchedCupertinoListTile(
            onTap: () {
              refreshValueChanged(15);
            },
            title: Text(
              '15 ${LocaleKeys.sec.tr()} - ${LocaleKeys.slow_title.tr()}',
            ),
            trailing: initialValue == 15 ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CustomNotchedCupertinoListTile(
            onTap: () {
              refreshValueChanged(20);
            },
            title: Text(
              '20 ${LocaleKeys.sec.tr()} - ${LocaleKeys.slower_title.tr()}',
            ),
            trailing: initialValue == 20 ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CustomNotchedCupertinoListTile(
            onTap: () {
              refreshValueChanged(0);
            },
            title: const Text(LocaleKeys.disabled_title).tr(),
            trailing: initialValue == 0 ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
        ],
      ),
    );
  }
}
