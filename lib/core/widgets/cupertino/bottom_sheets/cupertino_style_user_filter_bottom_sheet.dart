import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../../../features/users/presentation/bloc/users_bloc.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../base/sensitive_text.dart';
import '../buttons/cupertino_style_bottom_sheet_cancel_button.dart';
import '../cupertino_style_list_section.dart';
import '../cupertino_style_modal_popup_scaffold.dart';
import '../cupertino_style_notched_cupertino_list_tile.dart';

class CupertinoStyleUserFilterBottomSheet extends StatelessWidget {
  final int initialValue;

  const CupertinoStyleUserFilterBottomSheet({
    super.key,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, usersState) {
        return BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingsState) {
            settingsState as SettingsSuccess;

            return CupertinoStyleModalPopupScaffold(
              middleText: LocaleKeys.filter_user_title.tr(),
              leading: const CupertinoStyleBottomSheetCancelButton(),
              child: CupertinoStyleListSection(
                hasLeading: false,
                children: [
                  CupertinoStyleNotchedCupertinoListTile(
                    onTap: () => Navigator.of(context).pop(-1),
                    titleText: LocaleKeys.all_users_title.tr(),
                    trailing: initialValue == -1 ? const Icon(CupertinoIcons.checkmark_alt) : null,
                  ),
                  ...usersState.users.map(
                    (user) => CupertinoStyleNotchedCupertinoListTile(
                      onTap: () => Navigator.of(context).pop(user.userId),
                      titleText: user.friendlyName.sensitive(context) ?? '',
                      trailing: initialValue == user.userId ? const Icon(CupertinoIcons.checkmark_alt) : null,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
