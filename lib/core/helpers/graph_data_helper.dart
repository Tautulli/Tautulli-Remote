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

  static double horizontalStep(double maxYValue, String yAxisType) {
    if (yAxisType == 'duration') {
      List<double> bins = [1800, 3600, 10800, 21600];

      double durationBin;

      // If max y is more than 21600s (6h) then calculate a new bin in
      // increments of 21600s
      if (maxYValue > bins[bins.length - 1]) {
        durationBin = (maxYValue / 21600).ceilToDouble() * 21600;
      } else {
        for (double b in bins) {
          if (maxYValue <= b) {
            durationBin = b;
            break;
          }
        }
      }

      return durationBin / 6;
    }
    return (maxYValue / 5).ceilToDouble();
  }
}
