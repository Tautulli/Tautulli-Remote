import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../core/widgets/ios/ios_bottom_sheet_cancel_button.dart';
import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../../users/presentation/bloc/users_bloc.dart';

class HistoryUserFilterIosBottomSheet extends StatelessWidget {
  final int initialValue;

  const HistoryUserFilterIosBottomSheet({
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
              leading: const IosBottomSheetCancelButton(),
              child: SingleChildScrollView(
                child: CustomCupertinoListSection(
                  hasLeading: false,
                  children: usersState.users
                      .map(
                        (user) => CustomNotchedCupertinoListTile(
                          onTap: () => Navigator.of(context).pop(user.userId),
                          title: Text(
                            settingsState.appSettings.maskSensitiveInfo
                                ? LocaleKeys.hidden_message.tr()
                                : user.friendlyName ?? '',
                          ),
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
