import 'package:duration/duration.dart';
import 'package:intl/intl.dart';
import 'package:simple_moment/simple_moment.dart';

class TimeHelper {
  static String cleanDateTime(
    DateTime dateTime, {
    String? dateFormat,
    String? timeFormat,
    bool dateOnly = false,
    bool timeOnly = false,
  }) {
    final String parsedDateFormat = dateFormat != null ? _parseDateFormat(dateFormat) : 'y-MM-dd';
    final String parsedTimeFormat = timeFormat != null ? _parseTimeFormat(timeFormat) : 'HH:mm';

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

  static String eta(
    Duration? duration,
    int? progressPercent,
    String? timeFormat,
  ) {
    Duration time = Duration(
      milliseconds: ((duration?.inMilliseconds ?? 0) * (1 - ((progressPercent ?? 0) / 100))).round(),
    );

    DateTime eta = DateTime.now().add(time);

    final String parsedTimeFormat = timeFormat != null ? _parseTimeFormat(timeFormat) : 'HH:mm';

    return DateFormat(parsedTimeFormat).format(eta);
  }

  /// Converts a [Duration] to a `hh:mm:ss` format.
  static String hourMinSec(Duration duration) {
    if (duration.inHours <= 0) {
      return '${duration.inMinutes.remainder(60).toString().padLeft(1, "0")}:${duration.inSeconds.remainder(60).toString().padLeft(2, "0")}';
    } else {
      return '${duration.inHours}:${duration.inMinutes.remainder(60).toString().padLeft(2, "0")}:${duration.inSeconds.remainder(60).toString().padLeft(2, "0")}';
    }
  }

  static String logDate(
    int timeSinceEpochInMilliseconds, {
    String? dateFormat,
  }) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeSinceEpochInMilliseconds);

    final String parsedDateFormat = dateFormat != null ? _parseDateFormat(dateFormat) : 'y-MM-dd';

    return DateFormat(parsedDateFormat).format(dateTime).trim();
  }

  static String logTime(
    int timeSinceEpochInMilliseconds, {
    String? timeFormat,
  }) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeSinceEpochInMilliseconds);

    final String parsedTimeFormat = timeFormat != null ? '$_parseTimeFormat(timeFormat):ss' : 'HH:mm:ss';

    return DateFormat(parsedTimeFormat).format(dateTime).trim();
  }

  static String moment(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown';

    Moment moment = Moment.now();

    return moment.from(dateTime);
  }

  static String simple(Duration duration) {
    String hours = '';
    String minutes = '';
    String seconds = '';
    if (duration.inMinutes > 59) {
      if (duration.inHours == 1) {
        hours = '${duration.inHours.toString()} hour ';
      } else {
        hours = '${duration.inHours.toString()} hours ';
      }
    }
    if (duration.inMinutes > 0) {
      if (duration.inMinutes == 1) {
        minutes = '${duration.inMinutes.remainder(60).toString()} minute ';
      } else {
        minutes = '${duration.inMinutes.remainder(60).toString()} minutes ';
      }
    }
    if (duration.inMinutes < 1) {
      if (duration.inSeconds == 1) {
        seconds = '${duration.inSeconds.toString()} second';
      } else {
        seconds = '${duration.inSeconds.toString()} seconds';
      }
    }

    return '$hours$minutes$seconds';
  }

  /// Returns a cleaner version of [Duration].
  ///
  /// Example: `1h, 6m` or `10m, 5s`.
  static String timeLeft(Duration? duration, int? progressPercent) {
    Duration time = Duration(
      milliseconds: ((duration?.inMilliseconds ?? 0) * (1 - ((progressPercent ?? 0) / 100))).round(),
    );

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
