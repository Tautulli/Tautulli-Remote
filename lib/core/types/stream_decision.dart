enum StreamDecision {
  copy('copy'),
  directPlay('direct play'),
  transcode('transcode'),
  unknown('unknown');

  final String value;
  const StreamDecision(this.value);

  String apiValue() => value;
}
