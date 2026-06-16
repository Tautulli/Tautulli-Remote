import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/helpers/icon_helper.dart';
import '../../../../../core/helpers/time_helper.dart';
import '../../../../../core/types/media_type.dart';
import '../../../../../core/widgets/base/media_type_icon.dart';
import '../../../../../core/widgets/base/sensitive_text.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/history_model.dart';
import 'history_details_item_details_row.dart';
import 'history_details_subtitle_row.dart';

class HistoryCardDetails extends StatelessWidget {
  final HistoryModel history;
  final Color iconColor;
  final Widget titleRow;
  final bool showUser;

  const HistoryCardDetails({
    super.key,
    required this.history,
    required this.iconColor,
    required this.titleRow,
    this.showUser = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (previous, current) {
        if (previous is SettingsSuccess && current is SettingsSuccess) {
          return previous.appSettings.activeServer.dateFormat != current.appSettings.activeServer.dateFormat ||
              previous.appSettings.activeServer.timeFormat != current.appSettings.activeServer.timeFormat;
        }
        return true;
      },
      builder: (context, state) {
        state as SettingsSuccess;

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showUser)
                    Text(
                      history.fullTitle ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (!showUser) titleRow,
                  if (!showUser && history.mediaType != MediaType.movie)
                    HistoryDetailsSubtitleRow(
                      history,
                      maxLines: 1,
                      fontSize: 16,
                    ),
                  if (showUser)
                    HistoryDetailsItemDetailsRow(
                      history,
                      dateFormat: state.appSettings.activeServer.dateFormat,
                    ),
                  if (showUser)
                    Text(
                      history.friendlyName ?? '',
                      overflow: TextOverflow.ellipsis,
                    ).sensitive(),
                  if (!showUser)
                    HistoryDetailsItemDetailsRow(
                      history,
                      dateFormat: state.appSettings.activeServer.dateFormat,
                      fontSize: 16,
                    ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (history.stopped != null)
                  Text(
                    TimeHelper.cleanDateTime(
                      history.stopped!,
                      dateFormat: state.appSettings.activeServer.dateFormat,
                      timeFormat: state.appSettings.activeServer.timeFormat,
                    ),
                    style: TextStyle(fontSize: !showUser ? 16 : null),
                  ),
                Row(
                  children: [
                    MediaTypeIcon(
                      mediaType: history.mediaType,
                      iconColor: iconColor,
                    ),
                    const SizedBox(width: 5),
                    IconHelper.mapWatchedStatusToIcon(
                      context: context,
                      watchedStatus: history.watchedStatus,
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
