import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/widgets/cupertino/cupertino_style_modal_popup_scaffold.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_notched_cupertino_list_tile.dart';
import '../../../../../../core/widgets/cupertino/buttons/cupertino_style_bottom_sheet_cancel_button.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class CupertinoStyleServerTimeoutBottomSheet extends StatelessWidget {
  final int initialValue;

  const CupertinoStyleServerTimeoutBottomSheet({
    super.key,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    void timeoutValueChanged(int value) {
      context.read<SettingsBloc>().add(
        SettingsUpdateServerTimeout(value),
      );
      Navigator.of(context).pop();
    }

    return CupertinoStyleModalPopupScaffold(
      middleText: LocaleKeys.server_timeout_title.tr(),
      leading: const CupertinoStyleBottomSheetCancelButton(),
      child: CupertinoStyleListSection(
        hasLeading: false,
        children: [
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () {
              timeoutValueChanged(3);
            },
            titleText: '3 ${LocaleKeys.sec.tr()}',

            trailing: initialValue == 3 ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () {
              timeoutValueChanged(5);
            },
            titleText: '5 ${LocaleKeys.sec.tr()}',

            trailing: initialValue == 5 ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () {
              timeoutValueChanged(8);
            },
            titleText: '8 ${LocaleKeys.sec.tr()}',

            trailing: initialValue == 8 ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () {
              timeoutValueChanged(15);
            },
            titleText: '15 ${LocaleKeys.sec.tr()} (${LocaleKeys.default_title.tr()})',

            trailing: initialValue == 15 ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CupertinoStyleNotchedCupertinoListTile(
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
