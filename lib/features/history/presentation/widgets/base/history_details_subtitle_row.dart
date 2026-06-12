import 'package:flutter/widgets.dart';

import '../../../../../core/types/media_type.dart';
import '../../../data/models/history_model.dart';

class HistoryDetailsSubtitleRow extends StatelessWidget {
  final HistoryModel history;
  final int? maxLines;
  final double? fontSize;

  const HistoryDetailsSubtitleRow(
    this.history, {
    super.key,
    this.maxLines,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    int? lines;
    String text;

    switch (history.mediaType) {
      case (MediaType.episode):
        lines = 2;
        text = history.title ?? '';
        break;
      default:
        lines = 1;
        text = history.grandparentTitle ?? '';
        break;
    }

    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines ?? lines,
      style: TextStyle(fontSize: fontSize),
    );
  }
}
