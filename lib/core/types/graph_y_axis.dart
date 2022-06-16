enum GraphYAxis {
  plays('plays'),
  time('duration');

  final String value;
  const GraphYAxis(this.value);

  String apiValue() => value;
}
