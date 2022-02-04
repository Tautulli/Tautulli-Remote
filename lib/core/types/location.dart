enum Location {
  cellular,
  lan,
  wan,
  unknown,
}

extension ParseToString on Location {
  String toShortString() {
    return toString().split('.').last;
  }
}
