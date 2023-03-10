import 'package:filesize/filesize.dart';

class DataUnitHelper {
  static String prettyFilesize(int bytes) {
    return filesize(bytes, 1);
  }

  static String bitrate(
    int kiloBitsPerSecond, {
    int fractionDigits = 2,
  }) {
    if (kiloBitsPerSecond < 1000) {
      return '${kiloBitsPerSecond.toStringAsFixed(fractionDigits)} kbps';
    }

    return '${(kiloBitsPerSecond / 1000).toStringAsFixed(fractionDigits)} Mbps';
  }
}
