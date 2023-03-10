enum MediaType {
  album('album'),
  artist('artist'),
  clip('clip'),
  collection('collection'),
  episode('episode'),
  movie('movie'),
  otherVideo('other_video'),
  photo('photo'),
  photoAlbum('photo_album'),
  playlist('playlist'),
  season('season'),
  show('show'),
  track('track'),
  unknown('unknown');

  final String value;
  const MediaType(this.value);

  String apiValue() => value;
}
