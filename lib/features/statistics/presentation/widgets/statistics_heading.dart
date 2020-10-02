import 'package:flutter/material.dart';

import '../../../../core/helpers/color_palette_helper.dart';

class StatisticsHeading extends StatelessWidget {
  final String statId;

  const StatisticsHeading({
    Key key,
    @required this.statId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        _mapStatIdToHeading(statId),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: TautulliColorPalette.not_white,
        ),
      ),
    );
  }
}

String _mapStatIdToHeading(String statId) {
  switch (statId) {
    case ('top_tv'):
      return 'Most Watched TV Shows';
    case ('popular_tv'):
      return 'Most Popular TV Shows';
    case ('top_movies'):
      return 'Most Watched Movies';
    case ('popular_movies'):
      return 'Most Popular Movies';
    case ('top_music'):
      return 'Most Played Artists';
    case ('popular_music'):
      return 'Most Popular Artists';
    case ('last_watched'):
      return 'Recently Watched';
    case ('top_platforms'):
      return 'Most Active Platforms';
    case ('top_users'):
      return 'Most Active Users';
    case ('most_concurrent'):
      return 'Most Concurrent Streams';
    default:
      return 'UNKNOWN';
  }
}
