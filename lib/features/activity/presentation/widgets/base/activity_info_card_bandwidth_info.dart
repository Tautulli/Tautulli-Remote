import 'package:flutter/widgets.dart';

import '../../../../../core/helpers/data_unit_helper.dart';
import '../../../data/models/server_activity_model.dart';

class ActivityInfoCardBandwidthInfo extends StatelessWidget {
  final ServerActivityModel serverActivity;

  const ActivityInfoCardBandwidthInfo({
    super.key,
    required this.serverActivity,
  });

  @override
  Widget build(BuildContext context) {
    final int totalBandwidth = serverActivity.wanBandwidth + serverActivity.lanBandwidth;
    List<String> bandwidthBreakdowns = [];

    if (serverActivity.lanBandwidth > 0) {
      bandwidthBreakdowns.add('LAN: ${DataUnitHelper.bitrate(serverActivity.lanBandwidth)}');
    }
    if (serverActivity.wanBandwidth > 0) {
      bandwidthBreakdowns.add('WAN: ${DataUnitHelper.bitrate(serverActivity.wanBandwidth)}');
    }

    return Text(
      '${DataUnitHelper.bitrate(totalBandwidth)} ${bandwidthBreakdowns.isNotEmpty ? '(${bandwidthBreakdowns.join(', ')})' : ''}',
    );
  }
}
