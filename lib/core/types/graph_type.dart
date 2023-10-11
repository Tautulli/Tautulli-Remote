enum GraphType {
  concurrentStreams('Concurrent Streams'),
  playsByDate('Plays by Date'),
  playsByDayOfWeek('Plays by Day of Week'),
  playsByHourOfDay('Plays by Hour of Day'),
  playsBySourceResolution('Plays by Source Resolution'),
  playsByStreamResolution('Plays by Stream Resolution'),
  playsByStreamType('Plays by Stream Type'),
  playsByTop10Platforms('Plays by Top 10 Platforms'),
  playsByTop10Users('Plays by Top 10 Users'),
  streamTypeByTop10Platforms('Stream Type by Top 10 Platforms'),
  streamTypeByTop10Users('Stream Type by Top 10 Users'),
  playsPerMonth('Plays Per Month');

  final String value;
  const GraphType(this.value);

  String graphEndpoint() => value;
}
