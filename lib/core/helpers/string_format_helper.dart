/// Helper functions to manipulate string.
class StringFormatHelper {
  /// Capitalizes the first letter of a string.
  ///
  /// Throws an [ArgumentError] if string is null.
  static String capitalize(String string) {
    if (string == null) {
      throw ArgumentError("string: $string");
    }

    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1);
  }
}
