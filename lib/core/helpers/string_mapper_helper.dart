class StringMapperHelper {
  static String mapStatIdToTitle(String statId) {
    switch (statId) {
      case ('top_tv'):
        return 'Most Watched TV Shows';
      case ('popular_tv'):
        return 'Most Popular TV Shows';
      case ('top_movies'):
        return 'Most Watched Movies';
      case ('popular_movies'):
        return 'Most Popular Movies';
      case ('top_music'):
        return 'Most Played Artists';
      case ('popular_music'):
        return 'Most Popular Artists';
      case ('last_watched'):
        return 'Recently Watched';
      case ('top_platforms'):
        return 'Most Active Platforms';
      case ('top_users'):
        return 'Most Active Users';
      case ('most_concurrent'):
        return 'Most Concurrent Streams';
      case ('top_libraries'):
        return 'Most Active Libraries';
      default:
        return 'UNKNOWN';
    }
  }
}
