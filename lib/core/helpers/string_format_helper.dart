/// Helper functions to manipulate string.

// @dart=2.9

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

  /// Replaces all but the last 2 letters of [string] 
  /// with the same number of `*`.
  static String maskSensitiveInfo(String string) {
    final int maskLength = string.length - 2;
    String maskString = '';

    for (int i = maskLength; i > 0; i--) {
      maskString += '*';
    }

    return string.replaceRange(0, maskLength, maskString);
  }
}
