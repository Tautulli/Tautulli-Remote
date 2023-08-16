import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/icon_helper.dart';
import '../../../../core/helpers/time_helper.dart';
import '../../../../core/types/media_type.dart';
import '../../../../core/widgets/media_type_icon.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/history_model.dart';
import 'history_bottom_sheet_info.dart';

class HistoryCardDetails extends StatelessWidget {
  final HistoryModel history;
  final bool showUser;

  const HistoryCardDetails({
    super.key,
    required this.history,
    this.showUser = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
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
                        fontSize: 17,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (!showUser) TitleRow(history),
                  if (!showUser && history.mediaType != MediaType.movie)
                    SubtitleRow(
                      history,
                      maxLines: 1,
                    ),
                  if (showUser)
                    ItemDetailsRow(
                      history,
                      dateFormat: state.appSettings.activeServer.dateFormat,
                    ),
                  if (showUser)
                    Text(
                      state.appSettings.maskSensitiveInfo ? LocaleKeys.hidden_message.tr() : history.friendlyName ?? '',
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (!showUser)
                    ItemDetailsRow(
                      history,
                      dateFormat: state.appSettings.activeServer.dateFormat,
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
                  ),
                Row(
                  children: [
                    MediaTypeIcon(
                      mediaType: history.mediaType,
                      iconColor: Theme.of(context).colorScheme.onSurface,
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
