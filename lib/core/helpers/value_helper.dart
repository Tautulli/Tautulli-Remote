import 'package:meta/meta.dart';
import 'package:quiver/strings.dart';

enum CastType {
  bool,
  int,
  double,
  string,
}

class ValueHelper {
  /// Casts [value] to specified [CastType].
  ///
  /// If casting fails returns null.
  /// If nullEmptyString is true returns null when item is empty string.
  static dynamic cast({
    @required dynamic value,
    @required CastType type,
    bool nullEmptyString = true,
  }) {
    if (type == CastType.bool) {
      if ([1, true, '1', 'true'].contains(value)) {
        return true;
      } else if ([0, false, '0', 'false'].contains(value)) {
        return false;
      } else {
        return null;
      }
    }
    if (type == CastType.int) {
      return int.tryParse(value.toString());
    }
    if (type == CastType.double) {
      return double.tryParse(value.toString());
    }
    if (type == CastType.string) {
      if (isEmpty(value)) {
        if (nullEmptyString) {
          return null;
        } else {
          return '';
        }
      } else {
        return value.toString();
      }
    }
  }
}
