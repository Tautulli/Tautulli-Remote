enum ImageFallback {
  poster('poster'),
  cover('cover'),
  art('art'),
  posterLive('poster-live'),
  artLive('art-live'),
  artLiveFull('art-live-full'),
  user('user');

  final String value;
  const ImageFallback(this.value);

  String apiValue() => value;
}
