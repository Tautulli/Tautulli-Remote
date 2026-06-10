import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/types/media_type.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/history_model.dart';
import '../base/history_details_item_details_row.dart';
import '../base/history_details_subtitle_row.dart';
import '../base/history_details_title_row.dart';

class HistoryDetailsInfo extends StatelessWidget {
  final HistoryModel history;
  final double fontSize;

  const HistoryDetailsInfo({
    super.key,
    required this.history,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HistoryDetailsTitleRow(
          history: history,
          fontSize: fontSize,
        ),
        if (history.mediaType == MediaType.episode || history.mediaType == MediaType.track)
          HistoryDetailsSubtitleRow(history),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;

            return HistoryDetailsItemDetailsRow(
              history,
              dateFormat: state.appSettings.activeServer.dateFormat,
            );
          },
        ),
      ],
    );
  }
}
