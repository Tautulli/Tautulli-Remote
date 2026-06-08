import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

import '../../../../../translations/locale_keys.g.dart';
import '../../../data/models/server_activity_model.dart';

class ActivityInfoCardStreamsInfo extends StatelessWidget {
  final ServerActivityModel serverActivity;

  const ActivityInfoCardStreamsInfo({
    super.key,
    required this.serverActivity,
  });

  @override
  Widget build(BuildContext context) {
    final int streamCount = serverActivity.copyCount + serverActivity.directPlayCount + serverActivity.transcodeCount;
    List<String> streamBreakdowns = [];

    if (serverActivity.copyCount > 0) {
      streamBreakdowns.add('${serverActivity.copyCount} ${LocaleKeys.direct_stream_title.tr()}');
    }
    if (serverActivity.directPlayCount > 0) {
      streamBreakdowns.add('${serverActivity.directPlayCount} ${LocaleKeys.direct_play_title.tr()}');
    }
    if (serverActivity.transcodeCount > 0) {
      streamBreakdowns.add('${serverActivity.transcodeCount} ${LocaleKeys.transcode_title.tr()}');
    }

    return Text(
      '$streamCount ${LocaleKeys.streams_title.tr()} (${streamBreakdowns.join(', ')})',
    );
  }
}
