import '../../dependency_injection.dart' as di;
import '../../features/logging/domain/usecases/logging.dart';
import '../types/section_type.dart';
import '../types/tautulli_types.dart';
import '../types/theme_enhancement_type.dart';
import '../types/theme_type.dart';

class Cast {
  //* Dart Types

  /// Casts value to a boolean.
  ///
  /// Handles nums, double, int, String, and bool. Anything else returns null.
  static bool? castToBool(dynamic value) {
    switch (value.runtimeType) {
      case num:
        return (value as num?) == 0 ? false : true;
      case double:
        return (value as double?) == 0 ? false : true;
      case int:
        return (value as int?) == 0 ? false : true;
      case String:
        return (value as String?) == "" || value == "0" ? false : true;
      case bool:
        return (value as bool?);
      default:
        return null;
    }
  }

  /// Casts value to a double.
  ///
  /// Handles nums, double, int, String, and bool. Anything else returns null.
  static double? castToDouble(dynamic value) {
    switch (value.runtimeType) {
      case num:
        return (value as num).toDouble();
      case double:
        return (value as double?);
      case int:
        return (value as int).toDouble();
      case String:
        return double.tryParse(value as String);
      case bool:
        return (value as bool) ? 1 : 0;
      default:
        return null;
    }
  }

  /// Casts value to an integer.
  ///
  /// Handles nums, double, int, String, and bool. Anything else returns null.
  static int? castToInt(dynamic value) {
    switch (value.runtimeType) {
      case num:
        return (value as double).floor();
      case double:
        return (value as double).floor();
      case int:
        return (value as int?);
      case String:
        return int.tryParse(value as String);
      case bool:
        return (value as bool) ? 1 : 0;
      default:
        return null;
    }
  }

  /// Casts value to a num.
  ///
  /// Handles nums, double, int, String, and bool. Anything else returns null.
  static num? castToNum(dynamic value) {
    switch (value.runtimeType) {
      case num:
      case double:
      case int:
        return (value as num?);
      case String:
        return num.tryParse(value as String);
      case bool:
        return (value as bool) ? 1 : 0;
      default:
        return null;
    }
  }

  /// Casts value to a string.
  ///
  /// Handles nums, double, int, String, and bool. Anything else returns null.
  static String? castToString(dynamic value) {
    switch (value.runtimeType) {
      case double:
        return (value as double?).toString();
      case int:
        return (value as int?).toString();
      case String:
        return (value as String?);
      case bool:
        return (value as bool) ? "1" : "0";
      case PlayMetricType:
      case MediaType:
      case SectionType:
      case StatIdType:
      case StreamDecision:
      case ImageFallback:
        return value.apiValue();
      default:
        return null;
    }
  }

  //* Tautulli Types

  /// Casts `String` to a `GraphSeriesType`.
  ///
  /// Returns `GraphSeriesType.unknown` if no match is found.
  static GraphSeriesType castStringToGraphSeriesType(String value) {
    switch (value.toLowerCase()) {
      case ('tv'):
        return GraphSeriesType.tv;
      case ('movies'):
        return GraphSeriesType.movies;
      case ('music'):
        return GraphSeriesType.music;
      case ('live tv'):
        return GraphSeriesType.live;
      case ('direct play'):
        return GraphSeriesType.directPlay;
      case ('direct stream'):
        return GraphSeriesType.directStream;
      case ('transcode'):
        return GraphSeriesType.transcode;
      case ('max. concurrent streams'):
        return GraphSeriesType.concurrent;
      default:
        di.sl<Logging>().warning(
              'Utilities :: Failed to cast $value to GraphSeriesType',
            );
        return GraphSeriesType.unknown;
    }
  }

  /// Casts `String` to a `Location`.
  ///
  /// Returns `Location.unknown` if no match is found.
  static Location? castStringToLocation(String? value) {
    switch (value) {
      case ('lan'):
        return Location.lan;
      case ('wan'):
        return Location.wan;
      case ('cellular'):
        return Location.cellular;
      default:
        di.sl<Logging>().warning(
              'Utilities :: Failed to cast $value to Location',
            );
        return Location.unknown;
    }
  }

  /// Casts `String` to a `MediaType`.
  ///
  /// Returns `MediaType.unknown` if no match is found.
  static MediaType? castStringToMediaType(String? value) {
    switch (value) {
      case (null):
        return null;
      case ('album'):
        return MediaType.album;
      case ('artist'):
        return MediaType.artist;
      case ('clip'):
        return MediaType.clip;
      case ('collection'):
        return MediaType.collection;
      case ('episode'):
        return MediaType.episode;
      case ('movie'):
        return MediaType.movie;
      case ('photo'):
        return MediaType.photo;
      case ('photo_album'):
        return MediaType.photoAlbum;
      case ('playlist'):
        return MediaType.playlist;
      case ('season'):
        return MediaType.season;
      case ('show'):
        return MediaType.show;
      case ('track'):
        return MediaType.track;
      default:
        di.sl<Logging>().warning(
              'Utilities :: Failed to cast $value to MediaType',
            );
        return MediaType.unknown;
    }
  }

  /// Casts `String` to a `PlaybackState`.
  ///
  /// Returns `PlaybackState.unknown` if no match is found.
  static PlaybackState? castStringToPlaybackState(String? value) {
    switch (value) {
      case (null):
        return null;
      case ('buffering'):
        return PlaybackState.buffering;
      case ('error'):
        return PlaybackState.error;
      case ('paused'):
        return PlaybackState.paused;
      case ('playing'):
        return PlaybackState.playing;
      default:
        di.sl<Logging>().warning(
              'Utilities :: Failed to cast $value to PlaybackState',
            );
        return PlaybackState.unknown;
    }
  }

  /// Casts `String` to a `PlayMetricType`.
  ///
  /// Returns `PlayMetricType.unknown` if no match is found.
  static PlayMetricType? castStringToPlayMetricType(String? value) {
    switch (value) {
      case (null):
        return null;
      case ('plays'):
        return PlayMetricType.plays;
      case ('duration'):
        return PlayMetricType.time;
      default:
        di.sl<Logging>().warning(
              'Utilities :: Failed to cast $value to PlayMetricType',
            );
        return PlayMetricType.unknown;
    }
  }

  /// Casts `String` to a `SectionType`.
  ///
  /// Returns `SectionType.unknown` if no match is found.
  static SectionType? castStringToSectionType(String? value) {
    switch (value) {
      case (null):
        return null;
      case ('artist'):
        return SectionType.artist;
      case ('movie'):
        return SectionType.movie;
      case ('photo'):
        return SectionType.photo;
      case ('show'):
        return SectionType.show;
      default:
        di.sl<Logging>().warning(
              'Utilities :: Failed to cast $value to SectionType',
            );
        return SectionType.unknown;
    }
  }

  /// Casts `String` to a `StatIdType`.
  ///
  /// Returns `StatIdType.unknown` if no match is found.
  static StatIdType? castStringToStatIdType(String? value) {
    switch (value) {
      case (null):
        return null;
      case ('last_watched'):
        return StatIdType.lastWatched;
      case ('most_concurrent'):
        return StatIdType.mostConcurrent;
      case ('popular_movies'):
        return StatIdType.popularMovies;
      case ('popular_music'):
        return StatIdType.popularMusic;
      case ('popular_tv'):
        return StatIdType.popularTv;
      case ('top_libraries'):
        return StatIdType.topLibraries;
      case ('top_movies'):
        return StatIdType.topMovies;
      case ('top_music'):
        return StatIdType.topMusic;
      case ('top_platforms'):
        return StatIdType.topPlatforms;
      case ('top_tv'):
        return StatIdType.topTv;
      case ('top_users'):
        return StatIdType.topUsers;
      default:
        di.sl<Logging>().warning(
              'Utilities :: Failed to cast $value to StatIdType',
            );
        return StatIdType.unknown;
    }
  }

  /// Casts `String` to a `StreamDecision`.
  ///
  /// Returns `StreamDecision.unknown` if no match is found.
  static StreamDecision? castStringToStreamDecision(String? value) {
    switch (value) {
      case (null):
        return null;
      case ('copy'):
        return StreamDecision.copy;
      case ('direct play'):
        return StreamDecision.directPlay;
      case ('transcode'):
        return StreamDecision.transcode;
      case (''):
        return StreamDecision.none;
      default:
        di.sl<Logging>().warning(
              'Utilities :: Failed to cast $value to StreamDecision',
            );
        return StreamDecision.unknown;
    }
  }

  /// Casts `String` to a `SubtitleDecision`.
  ///
  /// Returns `SubtitleDecision.unknown` if no match is found.
  static SubtitleDecision? castStringToSubtitleDecision(String? value) {
    switch (value) {
      case (null):
        return null;
      case ('burn'):
        return SubtitleDecision.burn;
      case ('copy'):
        return SubtitleDecision.copy;
      case ('transcode'):
        return SubtitleDecision.transcode;
      case (''):
      case ('ignore'):
        return SubtitleDecision.none;
      default:
        di.sl<Logging>().warning(
              'Utilities :: Failed to cast $value to SubtitleDecision',
            );
        return SubtitleDecision.unknown;
    }
  }

  /// Casts `String` to a `VideoDynamicRange`.
  ///
  /// Returns `VideoDynamicRange.unknown` if no match is found.
  static VideoDynamicRange? castStringToVideoDynamicRange(String? value) {
    switch (value) {
      case (null):
        return null;
      case ('hdr'):
      case ('HDR'):
        return VideoDynamicRange.hdr;
      case ('sdr'):
      case ('SDR'):
        return VideoDynamicRange.sdr;
      default:
        di.sl<Logging>().warning(
              'Utilities :: Failed to cast $value to VideoDynamicRange',
            );
        return VideoDynamicRange.unknown;
    }
  }

  //* Tautulli Remote Types

  /// Casts `ThemeEnhancementType` to a `String`.
  ///
  /// Returns `none` if no match is found.
  static String castThemeEnhancementTypeToString(ThemeEnhancementType themeEnhancementType) {
    switch (themeEnhancementType) {
      case (ThemeEnhancementType.ultraContrastDark):
        return 'ultraContrastDark';
      default:
        return 'none';
    }
  }

  /// Casts `String` to a `ThemeEnhancementType`.
  ///
  /// Returns `ThemeEnhancementType.none` if no match is found.
  static ThemeEnhancementType castStringToThemeEnhancementType(String? value) {
    switch (value) {
      case ('ultraContrastDark'):
        return ThemeEnhancementType.ultraContrastDark;
      default:
        return ThemeEnhancementType.none;
    }
  }

  /// Casts `String` to a `ThemeType`.
  ///
  /// Returns `ThemeType.tautulli` if no match is found.
  static ThemeType castStringToThemeType(String value) {
    switch (value) {
      case ('dynamic'):
        return ThemeType.dynamic;
      default:
        return ThemeType.tautulli;
    }
  }
}
