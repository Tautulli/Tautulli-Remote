import 'package:flutter/widgets.dart';

import '../../../../../core/types/media_type.dart';
import '../../../data/models/history_model.dart';

class HistoryDetailsTitleRow extends StatelessWidget {
  final HistoryModel history;
  final double fontSize;

  const HistoryDetailsTitleRow({
    super.key,
    required this.history,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    int? maxLines;
    String text;

    switch (history.mediaType) {
      case (MediaType.episode):
        maxLines = 1;
        text = history.grandparentTitle ?? '';
        break;
      case (MediaType.movie):
        maxLines = 3;
        text = history.title ?? '';
        break;
      default:
        maxLines = 2;
        text = history.title ?? '';
    }

    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: fontSize,
      ),
    );
  }
}
