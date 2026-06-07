import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/widgets/ios/cupertino_modal_popup_scaffold.dart';
import '../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../core/widgets/ios/ios_bottom_sheet_cancel_button.dart';
import '../../../../users/presentation/bloc/users_bloc.dart';
import 'dialogs/cupertino_style_users_load_issue_dialog.dart';

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
    return CupertinoModalPopupScaffold(
      leading: const IosBottomSheetCancelButton(),
      //TODO: Translation string
      middleText: 'History Actions',
      child: CustomCupertinoListSection(
        children: [
          BlocBuilder<UsersBloc, UsersState>(
            builder: (context, state) {
              return CustomNotchedCupertinoListTile(
                inactive: state.status != BlocStatus.success,
                leading: Icon(
                  CupertinoIcons.person_fill,
                  color: ThemeHelper.cupertinoListTileIconColor(),
                ),
                //TODO: Translation string
                titleText: 'Select User',
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
          CustomNotchedCupertinoListTile(
            leading: Icon(
              CupertinoIcons.line_horizontal_3_decrease,
              color: ThemeHelper.cupertinoListTileIconColor(),
            ),
            //TODO: Translation string
            titleText: 'Filter History',
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
          CustomNotchedCupertinoListTile(
            isDestructive: true,
            leading: const Icon(
              CupertinoIcons.clear_circled_solid,
              color: CupertinoColors.destructiveRed,
            ),
            //TODO: Translation string
            titleText: 'Clear Filters',
            onTap: () {
              Navigator.of(context).pop('clear');
            },
          ),
        ],
      ),
    );
  }
}
