enum Location {
  cellular('cellular'),
  lan('lan'),
  wan('wan'),
  unknown('unknown');

  final String value;
  const Location(this.value);

  String apiValue() => value;
}
