enum PlayMetricType {
  plays('plays'),
  time('duration');

  final String value;
  const PlayMetricType(this.value);

  String apiValue() => value;
}
