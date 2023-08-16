import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../core/helpers/data_unit_helper.dart';
import '../../../../core/widgets/card_with_forced_tint.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../data/models/server_activity_model.dart';

class ServerActivityInfoCard extends StatelessWidget {
  final ServerActivityModel serverActivity;

  const ServerActivityInfoCard({
    super.key,
    required this.serverActivity,
  });

  @override
  Widget build(BuildContext context) {
    return CardWithForcedTint(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            FaIcon(
              FontAwesomeIcons.circleInfo,
              size: 22,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            const Gap(8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StreamsInfo(serverActivity: serverActivity),
                  _BandwidthInfo(serverActivity: serverActivity),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreamsInfo extends StatelessWidget {
  final ServerActivityModel serverActivity;

  const _StreamsInfo({
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
      '$streamCount Streams (${streamBreakdowns.join(', ')})',
    );
  }
}

class _BandwidthInfo extends StatelessWidget {
  final ServerActivityModel serverActivity;

  const _BandwidthInfo({
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
