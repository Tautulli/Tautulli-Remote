import 'package:filesize/filesize.dart';

class DataUnitFormatHelper {
  static String prettyFilesize(int bytes) {
    return filesize(bytes, 1);
  }

  static String bitrate(int kiloBitsPerSecond) {
    if (kiloBitsPerSecond < 1000) {
      return '${kiloBitsPerSecond.toStringAsFixed(2)} kbps';
    }

    return '${(kiloBitsPerSecond / 1000).toStringAsFixed(2)} Mbps';
  }
}
