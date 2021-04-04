import 'package:flutter/material.dart';

import '../../../../core/helpers/time_format_helper.dart';
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
        return statistic.title != null ? statistic.title : 'NO TITLE';
      case ('top_libraries'):
        return statistic.sectionName;
      case ('top_platforms'):
        return statistic.platform;
      case ('top_users'):
        return maskSensitiveInfo ? '*Hidden User*' : statistic.friendlyName;
      default:
        return 'UNKNOWN';
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
        return '${statistic.totalPlays} play${statistic.totalPlays > 1 ? "s" : ""}';
      case ('popular_tv'):
      case ('popular_movies'):
      case ('popular_music'):
        return '${statistic.usersWatched} users';
      case ('last_watched'):
        return maskSensitiveInfo ? '*Hidden User*' : statistic.friendlyName;
      case ('most_concurrent'):
        return '${statistic.count.toString()} streams';
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
