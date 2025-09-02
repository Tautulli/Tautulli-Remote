enum Framework {
  android,
  ios;

  String toShortString() => toString().split('.').last;
}
