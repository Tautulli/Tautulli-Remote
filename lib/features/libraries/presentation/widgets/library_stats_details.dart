import 'package:flutter/material.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/helpers/time_format_helper.dart';
import '../../domain/entities/library_statistic.dart';

class LibraryStatsDetails extends StatelessWidget {
  final LibraryStatistic statistic;
  final bool maskSensitiveInfo;

  const LibraryStatsDetails({
    Key key,
    @required this.statistic,
    @required this.maskSensitiveInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          _determineTitle(statistic),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 18),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'PLAYS ',
              ),
              TextSpan(
                text: statistic.totalPlays != null
                    ? statistic.totalPlays.toString()
                    : 'never',
                style: TextStyle(
                  color: PlexColorPalette.gamboge,
                ),
              ),
            ],
          ),
        ),
        if (statistic.libraryStatisticType == LibraryStatisticType.watchTime)
          _duration(),
      ],
    );
  }

  String _determineTitle(LibraryStatistic statistic) {
    if (statistic.libraryStatisticType == LibraryStatisticType.watchTime) {
      if (statistic.queryDays == 0) {
        return 'All Time';
      } else if (statistic.queryDays == 1) {
        return '24 Hours';
      } else {
        return '${statistic.queryDays} Days';
      }
    }

    return maskSensitiveInfo
        ? '*Hidden User Name*'
        : statistic.friendlyName.toString();
  }

  RichText _duration() {
    Map<String, int> durationMap = TimeFormatHelper.durationMap(
      Duration(seconds: statistic.totalTime ?? 0),
    );

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'DURATION ',
          ),
          if (durationMap['day'] > 0)
            TextSpan(
              children: [
                TextSpan(
                  text: durationMap['day'].toString(),
                  style: TextStyle(
                    color: PlexColorPalette.gamboge,
                  ),
                ),
                TextSpan(
                  text: ' days ',
                ),
              ],
            ),
          if (durationMap['hour'] > 0)
            TextSpan(
              children: [
                TextSpan(
                  text: durationMap['hour'].toString(),
                  style: TextStyle(
                    color: PlexColorPalette.gamboge,
                  ),
                ),
                TextSpan(
                  text: ' hrs ',
                ),
              ],
            ),
          if (durationMap['min'] > 0)
            TextSpan(
              children: [
                TextSpan(
                  text: durationMap['min'].toString(),
                  style: TextStyle(
                    color: PlexColorPalette.gamboge,
                  ),
                ),
                TextSpan(
                  text: ' mins',
                ),
              ],
            ),
          if (durationMap['day'] < 1 &&
              durationMap['hour'] < 1 &&
              durationMap['min'] < 1 &&
              durationMap['sec'] > 0)
            TextSpan(
              children: [
                TextSpan(
                  text: durationMap['sec'].toString(),
                  style: TextStyle(
                    color: PlexColorPalette.gamboge,
                  ),
                ),
                TextSpan(
                  text: ' secs',
                ),
              ],
            ),
          if (durationMap['day'] < 1 &&
              durationMap['hour'] < 1 &&
              durationMap['min'] < 1 &&
              durationMap['sec'] < 1)
            TextSpan(
              children: [
                TextSpan(
                  text: '0',
                  style: TextStyle(
                    color: PlexColorPalette.gamboge,
                  ),
                ),
                TextSpan(
                  text: ' min',
                ),
              ],
            ),
        ],
      ),
    );
  }
}
