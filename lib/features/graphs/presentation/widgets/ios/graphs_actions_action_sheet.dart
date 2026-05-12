import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/types/play_metric_type.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../history/presentation/widgets/ios/dialogs/users_load_issue_ios_dialog.dart';
import '../../../../users/presentation/bloc/users_bloc.dart';

class GraphsActionsActionSheet extends StatelessWidget {
  final int? userId;
  final PlayMetricType yAxis;

  const GraphsActionsActionSheet({
    super.key,
    required this.userId,
    required this.yAxis,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(
          LocaleKeys.cancel_title,
          style: TextStyle(color: ThemeHelper.cupertinoActionSheetActionColor()),
        ).tr(),
      ),
      actions: [
        BlocBuilder<UsersBloc, UsersState>(
          builder: (context, state) {
            return CupertinoActionSheetAction(
              onPressed: () async {
                if (state.status == BlocStatus.success) {
                  Navigator.of(context).pop('user');
                }
                if (state.status == BlocStatus.failure) {
                  await showCupertinoDialog(
                    context: context,
                    builder: (context) => const UsersLoadIssueIosDialog(),
                  );
                }
              },
              //TODO: Translation string
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    'Select User',
                    style: TextStyle(
                      color: state.status == BlocStatus.success
                          ? ThemeHelper.cupertinoActionSheetActionColor()
                          : CupertinoColors.inactiveGray,
                    ),
                  ).tr(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Visibility(
                      visible: userId != -1,
                      child: const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Icon(
                          CupertinoIcons.circle_fill,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Visibility(
                      visible: [BlocStatus.initial, BlocStatus.inProgress].contains(state.status),
                      child: const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: CupertinoActivityIndicator(),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Visibility(
                      visible: state.status == BlocStatus.failure,
                      child: const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Icon(
                          CupertinoIcons.exclamationmark_triangle_fill,
                          color: CupertinoColors.inactiveGray,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop('yAxis');
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              //TODO: Translation string
              Text(
                LocaleKeys.y_axis_title,
                style: TextStyle(color: ThemeHelper.cupertinoActionSheetActionColor()),
              ).tr(),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    yAxis == PlayMetricType.plays ? CupertinoIcons.number : CupertinoIcons.clock,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
