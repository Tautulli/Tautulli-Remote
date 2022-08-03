enum StatIdType {
  lastWatched('last_watched'),
  mostConcurrent('most_concurrent'),
  popularMovies('popular_movies'),
  popularMusic('popular_music'),
  popularTv('popular_tv'),
  topLibraries('top_libraries'),
  topMovies('top_movies'),
  topMusic('top_music'),
  topPlatforms('top_platforms'),
  topTv('top_tv'),
  topUsers('top_users'),
  unknown('unknown');

  final String value;
  const StatIdType(this.value);

  String apiValue() => value;
}
