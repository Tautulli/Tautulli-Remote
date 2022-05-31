import '../types/stream_decision.dart';

class StringHelper {
  /// Capitalizes the first letter of a string.
  static String capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1);
  }

  static String capitalizeAllWords(String string) {
    if (string.isEmpty) {
      return string;
    }

    return string.split(" ").map((str) => capitalize(str)).join(" ");
  }

  static String mapStreamDecisionToString(StreamDecision? streamDecision) {
    switch (streamDecision) {
      case (StreamDecision.copy):
        return 'Direct Stream';
      case (StreamDecision.directPlay):
        return 'Direct Play';
      case (StreamDecision.transcode):
        return 'Transcode';
      default:
        return '';
    }
  }
}
