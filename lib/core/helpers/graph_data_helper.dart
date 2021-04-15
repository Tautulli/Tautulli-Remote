import 'package:intl/intl.dart';

class GraphDataHelper {
  static String graphDate(
    String dateString, {
    bool includeWeekDay = false,
  }) {
    final dateFormat = includeWeekDay ? 'E MMM d' : 'MMM d';
    final parsedDateTime = DateTime.parse(dateString);
    final formatedDateString = DateFormat(dateFormat).format(parsedDateTime);
    return formatedDateString;
  }

  static String graphDuration(int durationInSeconds) {
    Duration time = Duration(seconds: durationInSeconds);

    if (time.inHours > 0) {
      return '${time.inHours}h ${time.inMinutes.remainder(60)}m';
    }

    return '${time.inMinutes.remainder(60)}m';
  }
}
