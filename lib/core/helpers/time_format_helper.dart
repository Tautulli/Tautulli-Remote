import 'package:duration/duration.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import 'package:simple_moment/simple_moment.dart';

import '../../translations/locale_keys.g.dart';

/// Provides helper functions to create more readable durations.
class TimeFormatHelper {
  /// Returns a cleaner version of [Duration].
  ///
  /// Example: `1h, 6m` or `10m, 5s`.
  static String timeLeft(int duration, int progressPercent) {
    Duration time = Duration(
        milliseconds: (duration * (1 - (progressPercent / 100))).round());

    if (time.inMinutes < 1) {
      return prettyDuration(
        time,
        abbreviated: true,
        tersity: DurationTersity.second,
      );
    } else {
      return prettyDuration(
        time,
        abbreviated: true,
        tersity: DurationTersity.minute,
      );
    }
  }

  static String pretty(int durationInSec) {
    Duration duration = Duration(seconds: durationInSec);

    String hours = '';
    String minutes = '';
    String seconds = '';
    if (duration.inMinutes > 59) {
      hours =
          '${duration.inHours.toString()} ${LocaleKeys.general_hours.tr()} ';
    }
    if (duration.inMinutes > 0) {
      minutes =
          '${duration.inMinutes.remainder(60).toString()} ${LocaleKeys.general_minutes.tr()} ';
    }
    if (duration.inMinutes < 1) {
      seconds =
          '${duration.inSeconds.toString()} ${LocaleKeys.general_seconds.tr()}';
    }

    return '$hours$minutes$seconds';
  }

  static String timeAgo(int addedAt) {
    Moment moment = Moment.now();

    return moment.from(DateTime.fromMillisecondsSinceEpoch(addedAt * 1000));
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

  static String eta(
    int duration,
    int progressPercent,
    String timeFormat,
  ) {
    Duration time = Duration(
        milliseconds: (duration * (1 - (progressPercent / 100))).round());

    DateTime eta = DateTime.now().add(time);

    final String parsedTimeFormat =
        timeFormat != null ? _parseTimeFormat(timeFormat) : 'HH:mm';

    return DateFormat("'ETA: '$parsedTimeFormat").format(eta);
  }

  static String cleanDateTime(
    int timeSinceEpochInSeconds, {
    String dateFormat,
    String timeFormat,
    bool dateOnly = false,
    bool timeOnly = false,
  }) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(timeSinceEpochInSeconds * 1000);

    final String parsedDateFormat =
        dateFormat != null ? _parseDateFormat(dateFormat) : 'y-MM-dd';
    final String parsedTimeFormat =
        timeFormat != null ? _parseTimeFormat(timeFormat) : 'HH:mm';

    return DateFormat(
      '${!timeOnly ? parsedDateFormat : ""} ${!dateOnly ? parsedTimeFormat : ""}',
    ).format(dateTime).trim();
  }

  static Map<String, int> durationMap(Duration duration) {
    return {
      'day': duration.inDays,
      'hour': duration.inHours.remainder(24),
      'min': duration.inMinutes.remainder(60),
      'sec': duration.inSeconds.remainder(60),
    };
  }
}

String _parseDateFormat(String dateFormat) {
  return dateFormat
      .replaceAll('YYYY', 'y')
      .replaceAll('YY', 'yy')
      // .replaceAll('MMMM', 'MMMM')
      // .replaceAll('MMM', 'MMM')
      // .replaceAll('MM', 'MM')
      // .replaceAll('M', 'M')
      .replaceAll('Mo', 'M')
      .replaceAll('dddd', 'EEEE')
      .replaceAll('ddd', 'E')
      .replaceAll('dd', 'E')
      .replaceAll('do', 'E')
      .replaceAll('d', 'E')
      .replaceAll('DDDo', 'DD')
      .replaceAll('DDDD', 'DDD')
      .replaceAll('DDD', 'DD')
      .replaceAll('DD', 'dd')
      .replaceAll('Do', 'd')
      .replaceAll('D', 'd');
}

String _parseTimeFormat(String timeFormat) {
  return timeFormat
      // .replaceAll('HH', 'HH')
      // .replaceAll('H', 'H')
      // .replaceAll('hh', 'hh')
      // .replaceAll('h', 'h')
      // .replaceAll('mm', 'mm')
      // .replaceAll('m', 'm')
      // .replaceAll('ss', 'ss')
      // .replaceAll('s', 's')
      .replaceAll('a', 'a')
      .replaceAll('A', 'a')
      .replaceAll('ZZ', '')
      .replaceAll('Z', '')
      .replaceAll('X', '');
}
