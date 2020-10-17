import 'package:filesize/filesize.dart';

class DataUnitFormatHelper {
  static String prettyFilesize(int bytes) {
    return filesize(bytes, 1);
  }
}
