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
