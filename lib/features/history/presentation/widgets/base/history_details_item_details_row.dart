import 'package:flutter/widgets.dart';

import '../../../../../core/helpers/time_helper.dart';
import '../../../../../core/types/media_type.dart';
import '../../../data/models/history_model.dart';

class HistoryDetailsItemDetailsRow extends StatelessWidget {
  final HistoryModel history;
  final String? dateFormat;

  const HistoryDetailsItemDetailsRow(
    this.history, {
    super.key,
    this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    final mediaType = history.mediaType;

    if (mediaType == MediaType.movie && history.year != null) {
      return Text(
        history.year.toString(),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    }

    if (mediaType == MediaType.episode && history.live == true && history.mediaIndex == null) {
      return Text(
        TimeHelper.cleanDateTime(
          history.date!,
          dateOnly: true,
          dateFormat: dateFormat,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    }

    if (mediaType == MediaType.episode && (history.parentMediaIndex != null || history.mediaIndex != null)) {
      return Text(
        '${history.parentMediaIndex != null ? "S${history.parentMediaIndex}" : ""}${history.parentMediaIndex != null && history.mediaIndex != null ? " • " : ""}${history.mediaIndex != null ? "E${history.mediaIndex}" : ""}',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    }

    if (mediaType == MediaType.track) {
      return Text(
        history.parentTitle ?? '',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    }

    return const SizedBox(height: 0, width: 0);
  }
}
