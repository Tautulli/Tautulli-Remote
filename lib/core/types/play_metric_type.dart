enum PlayMetricType {
  plays('plays'),
  time('duration'),
  unknown('unknown');

  final String value;
  const PlayMetricType(this.value);

  String apiValue() => value;
}
