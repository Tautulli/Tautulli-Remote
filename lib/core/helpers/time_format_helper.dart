import 'package:duration/duration.dart';

/// Provides helper functions to create more readable durations.
class TimeFormatHelper {
  /// Returns a cleaner version of [Duration].
  ///
  /// Example: `1h, 6m` or `10m, 5s`.
  static String timeLeft(int duration, int progressPercent) {
    Duration time = Duration(
        milliseconds: (duration * (1 - (progressPercent / 100))).round());

    if (time.inMinutes < 1) {
      return prettyDuration(time,
          abbreviated: true, tersity: DurationTersity.second);
    } else {
      return prettyDuration(time,
          abbreviated: true, tersity: DurationTersity.minute);
    }
  }

  /// Converts a [Duration] to a `mm:ss` format.
  static String minSec(Duration duration) {
    return '${duration.inMinutes}:${duration.inSeconds.remainder(60).toString().padLeft(2, "0")}';
  }

  /// Converts a [Duration] to a `hh:mm:ss` format.
  static String hourMinSec(Duration duration) {
    if (duration.inHours <= 0) {
      return '${duration.inMinutes.remainder(60).toString().padLeft(1, "0")}:${duration.inSeconds.remainder(60).toString().padLeft(2, "0")}';
    } else {
      return '${duration.inHours}:${duration.inMinutes.remainder(60).toString().padLeft(2, "0")}:${duration.inSeconds.remainder(60).toString().padLeft(2, "0")}';
    }
  }
}
