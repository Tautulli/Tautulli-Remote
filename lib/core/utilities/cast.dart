import '../../dependency_injection.dart' as di;
import '../../features/logging/domain/usecases/logging.dart';
import '../types/types.dart';

class Cast {
  // Dart Types

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
      default:
        return null;
    }
  }

  // Tautulli Types

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
}
