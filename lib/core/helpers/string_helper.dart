import 'package:easy_localization/easy_localization.dart';

import '../../translations/locale_keys.g.dart';
import '../types/tautulli_types.dart';

class StringHelper {
  /// Capitalizes the first letter of a string.
  static String capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1);
  }

  static String capitalizeAllWords(String string) {
    if (string.isEmpty) {
      return string;
    }

    return string.split(" ").map((str) => capitalize(str)).join(" ");
  }

  static String mapSeriesTypeToString(GraphSeriesType seriesType) {
    switch (seriesType) {
      case (GraphSeriesType.tv):
        return 'TV';
      case (GraphSeriesType.movies):
        return LocaleKeys.movies_title.tr();
      case (GraphSeriesType.music):
        return LocaleKeys.music_title.tr();
      case (GraphSeriesType.live):
        return LocaleKeys.live_title.tr();
      case (GraphSeriesType.directPlay):
        return LocaleKeys.direct_play_title.tr();
      case (GraphSeriesType.directStream):
        return LocaleKeys.direct_stream_title.tr();
      case (GraphSeriesType.transcode):
        return LocaleKeys.transcode_title.tr();
      case (GraphSeriesType.concurrent):
        return LocaleKeys.max_concurrent_title.tr();
      default:
        return 'Unknown';
    }
  }

  static String mapStatIdTypeToString(StatIdType? statIdType) {
    switch (statIdType) {
      case (StatIdType.lastWatched):
        return LocaleKeys.recently_watched_title.tr();
      case (StatIdType.mostConcurrent):
        return LocaleKeys.most_concurrent_streams_title.tr();
      case (StatIdType.popularMovies):
        return LocaleKeys.most_popular_movies_title.tr();
      case (StatIdType.popularMusic):
        return LocaleKeys.most_popular_artists_title.tr();
      case (StatIdType.popularTv):
        return LocaleKeys.most_popular_tv_shows_title.tr();
      case (StatIdType.topLibraries):
        return LocaleKeys.most_active_libraries_title.tr();
      case (StatIdType.topMovies):
        return LocaleKeys.most_watched_movies_title.tr();
      case (StatIdType.topMusic):
        return LocaleKeys.most_played_artists_title.tr();
      case (StatIdType.topPlatforms):
        return LocaleKeys.most_active_platforms_title.tr();
      case (StatIdType.topTv):
        return LocaleKeys.most_watched_tv_shows_title.tr();
      case (StatIdType.topUsers):
        return LocaleKeys.most_active_users_title.tr();
      default:
        return 'Unknown';
    }
  }

  static String mapStreamDecisionToString(StreamDecision? streamDecision) {
    switch (streamDecision) {
      case (StreamDecision.copy):
        return LocaleKeys.direct_stream_title.tr();
      case (StreamDecision.directPlay):
        return LocaleKeys.direct_play_title.tr();
      case (StreamDecision.transcode):
        return LocaleKeys.transcode_title.tr();
      default:
        return '';
    }
  }
}
