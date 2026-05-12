import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../../features/users/presentation/bloc/users_bloc.dart';
import '../../../translations/locale_keys.g.dart';
import 'custom_cupertino_list_section.dart';
import 'custom_notched_cupertino_list_tile.dart';
import 'ios_bottom_sheet_cancel_button.dart';
import 'page_scaffold_cupertino.dart';

class UserFilterIosBottomSheet extends StatelessWidget {
  final int initialValue;

  const UserFilterIosBottomSheet({
    super.key,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, usersState) {
        return BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingsState) {
            settingsState as SettingsSuccess;

            return PageScaffoldCupertino(
              //TODO: Add translation string
              middle: const Text('Filter User'),
              showBackButton: false,
              leading: const IosBottomSheetCancelButton(),
              child: SingleChildScrollView(
                child: CustomCupertinoListSection(
                  hasLeading: false,
                  children: usersState.users
                      .map(
                        (user) => CustomNotchedCupertinoListTile(
                          onTap: () => Navigator.of(context).pop(user.userId),
                          titleText: settingsState.appSettings.maskSensitiveInfo && user.userId != -1
                              ? LocaleKeys.hidden_message.tr()
                              : user.friendlyName ?? '',

                          trailing: initialValue == user.userId ? const Icon(CupertinoIcons.checkmark_alt) : null,
                        ),
                      )
                      .toList(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
