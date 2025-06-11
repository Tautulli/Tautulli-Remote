import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tautulli_remote/core/widgets/ios/custom_cupertino_list_section.dart';
import 'package:tautulli_remote/core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import 'package:tautulli_remote/core/widgets/ios/ios_bottom_sheet_cancel_button.dart';
import 'package:tautulli_remote/core/widgets/ios/page_scaffold_cupertino.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/translations/locale_keys.g.dart';

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

    return PageScaffoldCupertino(
      middle: const Text(LocaleKeys.server_timeout_title).tr(),
      leading: const IosBottomSheetCancelButton(),
      child: CustomCupertinoListSection(
        hasLeading: false,
        children: [
          CustomNotchedCupertinoListTile(
            onTap: () {
              timeoutValueChanged(3);
            },
            title: Text(
              '3 ${LocaleKeys.sec.tr()}',
            ),
            trailing: initialValue == 3 ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CustomNotchedCupertinoListTile(
            onTap: () {
              timeoutValueChanged(5);
            },
            title: Text(
              '5 ${LocaleKeys.sec.tr()}',
            ),
            trailing: initialValue == 5 ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CustomNotchedCupertinoListTile(
            onTap: () {
              timeoutValueChanged(8);
            },
            title: Text(
              '8 ${LocaleKeys.sec.tr()}',
            ),
            trailing: initialValue == 8 ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CustomNotchedCupertinoListTile(
            onTap: () {
              timeoutValueChanged(15);
            },
            title: Text(
              '15 ${LocaleKeys.sec.tr()} (${LocaleKeys.default_title.tr()})',
            ),
            trailing: initialValue == 15 ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CustomNotchedCupertinoListTile(
            onTap: () {
              timeoutValueChanged(30);
            },
            title: Text(
              '30 ${LocaleKeys.sec.tr()}',
            ),
            trailing: initialValue == 30 ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
        ],
      ),
    );
  }
}
