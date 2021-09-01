// @dart=2.9

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/helpers/data_unit_format_helper.dart';

class BandwidthHeader extends StatelessWidget {
  final Map bandwidthMap;

  const BandwidthHeader({
    Key key,
    @required this.bandwidthMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wanBandwidth =
        DataUnitFormatHelper.bitrate(bandwidthMap["wan"], fractionDigits: 1);
    final lanBandwidth =
        DataUnitFormatHelper.bitrate(bandwidthMap["lan"], fractionDigits: 1);
    final totalBandwidth = DataUnitFormatHelper.bitrate(
        bandwidthMap["wan"] + bandwidthMap["lan"],
        fractionDigits: 1);

    if (bandwidthMap != null &&
        (bandwidthMap['lan'] > 0 || bandwidthMap['wan'] > 0)) {
      return Row(
        children: [
          const FaIcon(
            FontAwesomeIcons.networkWired,
            color: Colors.grey,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            '$totalBandwidth (${bandwidthMap["lan"] > 0 ? "LAN: $lanBandwidth" : ""}${bandwidthMap["lan"] > 0 && bandwidthMap["wan"] > 0 ? ', ' : ''}${bandwidthMap["wan"] > 0 ? "WAN: $wanBandwidth" : ""})',
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      );
    }

    return const SizedBox(width: 0, height: 0);
  }
}
