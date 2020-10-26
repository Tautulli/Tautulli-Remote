import 'package:meta/meta.dart';

import '../../domain/entities/statistics.dart';

class StatisticsModel extends Statistics {
  StatisticsModel({
    // final String art,
    // final String contentRating,
    final int count,
    final String friendlyName,
    final String grandparentThumb,
    // final String guid,
    // final List labels,
    // final int lastPlay,
    final int lastWatch,
    // final int live,
    final String mediaType,
    final String platform,
    final String platformName,
    // final String player,
    final int ratingKey,
    final int rowId,
    final int sectionId,
    final int started,
    // final int stopped,
    final String statId,
    final String thumb,
    final String title,
    final int totalDuration,
    final int totalPlays,
    final String user,
    final int userId,
    final int usersWatched,
    final String userThumb,
    String posterUrl,
  }) : super(
          // art: art,
          // contentRating: contentRating,
          count: count,
          friendlyName: friendlyName,
          grandparentThumb: grandparentThumb,
          // guid: guid,
          // labels: labels,
          // lastPlay: lastPlay,
          lastWatch: lastWatch,
          // live: live,
          mediaType: mediaType,
          platform: platform,
          platformName: platformName,
          // player: player,
          ratingKey: ratingKey,
          rowId: rowId,
          sectionId: sectionId,
          started: started,
          // stopped: stopped,
          statId: statId,
          thumb: thumb,
          title: title,
          totalDuration: totalDuration,
          totalPlays: totalPlays,
          user: user,
          userId: userId,
          usersWatched: usersWatched,
          userThumb: userThumb,
          posterUrl: posterUrl,
        );

  factory StatisticsModel.fromJson({
    @required String statId,
    @required Map<String, dynamic> json,
  }) {
    return StatisticsModel(
      count: json.containsKey('count') ? json['count'] : null,
      friendlyName:
          json.containsKey('friendly_name') && json['friendly_name'] != ''
              ? json['friendly_name']
              : null,
      grandparentThumb: json.containsKey('grandparent_thumb') &&
              json['grandparent_thumb'] != ''
          ? json['grandparent_thumb']
          : null,
      lastWatch: json.containsKey('last_watch')
          ? json['last_watch']
          : json.containsKey('last_play') ? json['last_play'] : null,
      mediaType: json.containsKey('media_type') ? json['media_type'] : null,
      platform: json.containsKey('platform') && json['platform'] != ''
          ? json['platform']
          : null,
      platformName:
          json.containsKey('platform_name') ? json['platform_name'] : null,
      ratingKey: json.containsKey('rating_key') && json['rating_key'] != ''
          ? json['rating_key']
          : null,
      rowId: json.containsKey('row_id') && json['row_id'] != ''
          ? json['row_id']
          : null,
      sectionId: json.containsKey('section_id') && json['section_id'] != '' ? json['section_id'] : null,
      started:
          json.containsKey('started') ? int.tryParse(json['started']) : null,
      statId: statId,
      thumb: json.containsKey('thumb') && json['thumb'] != ''
          ? json['thumb']
          : null,
      title: json.containsKey('title') && json['title'] != ''
          ? json['title']
          : null,
      totalDuration:
          json.containsKey('total_duration') ? json['total_duration'] : null,
      totalPlays: json.containsKey('total_plays') ? json['total_plays'] : null,
      user:
          json.containsKey('user') && json['user'] != '' ? json['user'] : null,
      userId: json.containsKey('user_id') ? json['user_id'] : null,
      usersWatched:
          json.containsKey('users_watched') && json['users_watched'] != ''
              ? json['users_watched']
              : null,
      userThumb: json.containsKey('user_thumb') ? json['user_thumb'] : null,
    );
  }
}
