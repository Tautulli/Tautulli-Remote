import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/time_format_helper.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../domain/entities/statistics.dart';

class StatisticsDetails extends StatelessWidget {
  final Statistics statistic;
  final bool maskSensitiveInfo;

  const StatisticsDetails({
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
          _rowOne(),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        Text(
          _rowTwo(),
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
        Text(
          _rowThree(),
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  String _rowOne() {
    switch (statistic.statId) {
      case ('top_tv'):
      case ('popular_tv'):
      case ('top_movies'):
      case ('popular_movies'):
      case ('top_music'):
      case ('popular_music'):
      case ('last_watched'):
      case ('most_concurrent'):
        return statistic.title != null
            ? statistic.title
            : LocaleKeys.statistics_no_title.tr();
      case ('top_libraries'):
        return statistic.sectionName;
      case ('top_platforms'):
        return statistic.platform;
      case ('top_users'):
        return maskSensitiveInfo
            ? '*${LocaleKeys.masked_info_user.tr()}*'
            : statistic.friendlyName;
      default:
        return LocaleKeys.general_unknown.tr();
    }
  }

  String _rowTwo() {
    switch (statistic.statId) {
      case ('top_tv'):
      case ('top_movies'):
      case ('top_music'):
      case ('top_platforms'):
      case ('top_users'):
      case ('top_libraries'):
        return '${statistic.totalPlays} ${statistic.totalPlays > 1 ? LocaleKeys.general_plays.tr() : LocaleKeys.general_play.tr()}';
      case ('popular_tv'):
      case ('popular_movies'):
      case ('popular_music'):
        return '${statistic.usersWatched} ${LocaleKeys.general_users.tr()}';
      case ('last_watched'):
        return maskSensitiveInfo
            ? '*${LocaleKeys.masked_info_user.tr()}*'
            : statistic.friendlyName;
      case ('most_concurrent'):
        return '${statistic.count.toString()} ${LocaleKeys.general_streams.tr()}';
      default:
        return statistic.statId;
    }
  }

  String _rowThree() {
    switch (statistic.statId) {
      case ('top_tv'):
      case ('top_movies'):
      case ('top_music'):
      case ('top_platforms'):
      case ('top_users'):
      case ('top_libraries'):
        return TimeFormatHelper.pretty(statistic.totalDuration);
      case ('popular_tv'):
      case ('popular_movies'):
      case ('popular_music'):
      case ('last_watched'):
        return TimeFormatHelper.timeAgo(statistic.lastWatch);
      case ('most_concurrent'):
        return TimeFormatHelper.cleanDateTime(statistic.started);
      default:
        return statistic.statId;
    }
  }
}
