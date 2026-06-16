import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tautulli_remote/translations/locale_keys.g.dart';

import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/types/bloc_status.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_modal_popup_scaffold.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_notched_cupertino_list_tile.dart';
import '../../../../../../core/widgets/cupertino/buttons/cupertino_style_bottom_sheet_cancel_button.dart';
import '../../../../../users/presentation/bloc/users_bloc.dart';
import '../dialogs/cupertino_style_users_load_issue_dialog.dart';

class CupertinoStyleHistoryActionsBottomSheet extends StatelessWidget {
  final int? userId;
  final bool filterApplied;

  const CupertinoStyleHistoryActionsBottomSheet({
    super.key,
    required this.userId,
    required this.filterApplied,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoStyleModalPopupScaffold(
      leading: const CupertinoStyleBottomSheetCancelButton(),
      middleText: LocaleKeys.history_actions_title.tr(),
      child: CupertinoStyleListSection(
        children: [
          BlocBuilder<UsersBloc, UsersState>(
            builder: (context, state) {
              return CupertinoStyleNotchedCupertinoListTile(
                inactive: state.status != BlocStatus.success,
                leading: const Icon(
                  CupertinoIcons.person_fill,
                  color: ThemeHelper.cupertinoListTileIconColor,
                ),
                titleText: LocaleKeys.select_user_title.tr(),
                trailing: Builder(
                  builder: (context) {
                    if (userId != -1) {
                      return const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Icon(
                          CupertinoIcons.circle_fill,
                          size: 18,
                        ),
                      );
                    }

                    if ([BlocStatus.initial, BlocStatus.inProgress].contains(state.status)) {
                      return const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: CupertinoActivityIndicator(),
                      );
                    }

                    if (state.status == BlocStatus.failure) {
                      return const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Icon(
                          CupertinoIcons.exclamationmark_triangle_fill,
                          color: CupertinoColors.inactiveGray,
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                ),
                onTap: () async {
                  if (state.status == BlocStatus.success) {
                    Navigator.of(context).pop('user');
                  }
                  if (state.status == BlocStatus.failure) {
                    await showCupertinoDialog(
                      context: context,
                      builder: (context) => const CupertinoStyleUsersLoadIssueDialog(),
                    );
                  }
                },
              );
            },
          ),
          CupertinoStyleNotchedCupertinoListTile(
            leading: const Icon(
              CupertinoIcons.line_horizontal_3_decrease,
              color: ThemeHelper.cupertinoListTileIconColor,
            ),
            titleText: LocaleKeys.filter_history_title.tr(),
            trailing: Visibility(
              visible: filterApplied,
              child: const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(
                  CupertinoIcons.circle_fill,
                  size: 18,
                ),
              ),
            ),
            onTap: () {
              Navigator.of(context).pop('filter');
            },
          ),
          CupertinoStyleNotchedCupertinoListTile(
            isDestructive: true,
            leading: const Icon(
              CupertinoIcons.clear_circled_solid,
              color: CupertinoColors.destructiveRed,
            ),
            titleText: LocaleKeys.clear_filters_title.tr(),
            onTap: () {
              Navigator.of(context).pop('clear');
            },
          ),
        ],
      ),
    );
  }
}
