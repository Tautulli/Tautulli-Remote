import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/helpers/time_format_helper.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../domain/entities/user_statistic.dart';

class UserStatsDetails extends StatelessWidget {
  final UserStatistic statistic;
  final bool maskSensitiveInfo;

  const UserStatsDetails({
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
          style: const TextStyle(fontSize: 18),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${LocaleKeys.general_plays.tr()} ',
              ),
              TextSpan(
                text: statistic.totalPlays != null
                    ? statistic.totalPlays.toString()
                    : LocaleKeys.general_never.tr(),
                style: const TextStyle(
                  color: PlexColorPalette.gamboge,
                ),
              ),
            ],
          ),
        ),
        if (statistic.userStatisticType == UserStatisticType.watchTime)
          _duration(),
      ],
    );
  }

  String _determineTitle(UserStatistic statistic) {
    if (statistic.userStatisticType == UserStatisticType.watchTime) {
      if (statistic.queryDays == 0) {
        return LocaleKeys.general_details_all_time.tr();
      } else if (statistic.queryDays == 1) {
        return '24 ${LocaleKeys.general_details_hours.tr()}';
      } else {
        return '${statistic.queryDays} ${LocaleKeys.general_filter_days.tr()}';
      }
    }

    return maskSensitiveInfo
        ? '*${LocaleKeys.masked_info_player_name.tr()}*'
        : statistic.playerName.toString();
  }

  RichText _duration() {
    Map<String, int> durationMap = TimeFormatHelper.durationMap(
      Duration(seconds: statistic.totalTime ?? 0),
    );

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${LocaleKeys.general_details_duration.tr()} ',
          ),
          if (durationMap['day'] > 0)
            TextSpan(
              children: [
                TextSpan(
                  text: durationMap['day'].toString(),
                  style: const TextStyle(
                    color: PlexColorPalette.gamboge,
                  ),
                ),
                TextSpan(
                  text: ' ${LocaleKeys.general_details_days.tr()} ',
                ),
              ],
            ),
          if (durationMap['hour'] > 0)
            TextSpan(
              children: [
                TextSpan(
                  text: durationMap['hour'].toString(),
                  style: const TextStyle(
                    color: PlexColorPalette.gamboge,
                  ),
                ),
                TextSpan(
                  text: ' ${LocaleKeys.general_details_hrs.tr()} ',
                ),
              ],
            ),
          if (durationMap['min'] > 0)
            TextSpan(
              children: [
                TextSpan(
                  text: durationMap['min'].toString(),
                  style: const TextStyle(
                    color: PlexColorPalette.gamboge,
                  ),
                ),
                TextSpan(
                  text: ' ${LocaleKeys.general_details_mins.tr()}',
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
                  style: const TextStyle(
                    color: PlexColorPalette.gamboge,
                  ),
                ),
                TextSpan(
                  text: ' ${LocaleKeys.general_details_secs.tr()}',
                ),
              ],
            ),
          if (durationMap['day'] < 1 &&
              durationMap['hour'] < 1 &&
              durationMap['min'] < 1 &&
              durationMap['sec'] < 1)
            TextSpan(
              children: [
                const TextSpan(
                  text: '0',
                  style: TextStyle(
                    color: PlexColorPalette.gamboge,
                  ),
                ),
                TextSpan(
                  text: ' ${LocaleKeys.general_details_min.tr()}',
                ),
              ],
            ),
        ],
      ),
    );
  }
}
