import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/widgets/ios/cupertino_modal_popup_scaffold.dart';
import '../../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../../core/widgets/ios/ios_bottom_sheet_cancel_button.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class ServerTimeoutIosBottomSheet extends StatelessWidget {
  final int initialValue;

  const ServerTimeoutIosBottomSheet({
    super.key,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    void timeoutValueChanged(int value) {
      context.read<SettingsBloc>().add(
        SettingsUpdateServerTimeout(value),
      );
      Navigator.of(context).pop();
    }

    return CupertinoModalPopupScaffold(
      middleText: LocaleKeys.server_timeout_title.tr(),
      leading: const IosBottomSheetCancelButton(),
      child: CustomCupertinoListSection(
        hasLeading: false,
        children: [
          CustomNotchedCupertinoListTile(
            onTap: () {
              timeoutValueChanged(3);
            },
            titleText: '3 ${LocaleKeys.sec.tr()}',

            trailing: initialValue == 3 ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CustomNotchedCupertinoListTile(
            onTap: () {
              timeoutValueChanged(5);
            },
            titleText: '5 ${LocaleKeys.sec.tr()}',

            trailing: initialValue == 5 ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CustomNotchedCupertinoListTile(
            onTap: () {
              timeoutValueChanged(8);
            },
            titleText: '8 ${LocaleKeys.sec.tr()}',

            trailing: initialValue == 8 ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CustomNotchedCupertinoListTile(
            onTap: () {
              timeoutValueChanged(15);
            },
            titleText: '15 ${LocaleKeys.sec.tr()} (${LocaleKeys.default_title.tr()})',

            trailing: initialValue == 15 ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CustomNotchedCupertinoListTile(
            onTap: () {
              timeoutValueChanged(30);
            },
            titleText: '30 ${LocaleKeys.sec.tr()}',

            trailing: initialValue == 30 ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
        ],
      ),
    );
  }
}
