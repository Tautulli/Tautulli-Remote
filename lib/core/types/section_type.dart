enum SectionType {
  artist('artist'),
  movie('movie'),
  live('live'),
  photo('photo'),
  playlist('playlist'),
  show('show'),
  video('video'),
  unknown('unknown');

  final String value;
  const SectionType(this.value);

  String apiValue() => value;
}
