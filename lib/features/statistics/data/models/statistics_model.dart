import 'package:meta/meta.dart';

import '../../../../core/helpers/value_helper.dart';
import '../../domain/entities/statistics.dart';

class StatisticsModel extends Statistics {
  StatisticsModel({
    // final String art,
    // final String contentRating,
    final int count,
    final String friendlyName,
    final String grandchildTitle,
    final String grandparentThumb,
    final String grandparentTitle,
    // final String guid,
    // final List labels,
    // final int lastPlay,
    final int lastWatch,
    // final int live,
    final int mediaIndex,
    final String mediaType,
    final int parentMediaIndex,
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
    final int year,
    String posterUrl,
  }) : super(
          // art: art,
          // contentRating: contentRating,
          count: count,
          friendlyName: friendlyName,
          grandchildTitle: grandchildTitle,
          grandparentThumb: grandparentThumb,
          grandparentTitle: grandparentTitle,
          // guid: guid,
          // labels: labels,
          // lastPlay: lastPlay,
          lastWatch: lastWatch,
          // live: live,
          mediaIndex: mediaIndex,
          mediaType: mediaType,
          parentMediaIndex: parentMediaIndex,
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
          year: year,
          posterUrl: posterUrl,
        );

  factory StatisticsModel.fromJson({
    @required String statId,
    @required Map<String, dynamic> json,
  }) {
    return StatisticsModel(
      count: json.containsKey('count')
          ? ValueHelper.cast(
              value: json['count'],
              type: CastType.int,
            )
          : null,
      friendlyName: json.containsKey('friendly_name')
          ? ValueHelper.cast(
              value: json['friendly_name'],
              type: CastType.string,
            )
          : null,
      grandchildTitle: json.containsKey('grandchild_title')
          ? ValueHelper.cast(
              value: json['grandchild_title'],
              type: CastType.string,
            )
          : null,
      grandparentTitle: json.containsKey('grandparent_title')
          ? ValueHelper.cast(
              value: json['grandparent_title'],
              type: CastType.string,
            )
          : null,
      grandparentThumb: json.containsKey('grandparent_thumb')
          ? ValueHelper.cast(
              value: json['grandparent_thumb'],
              type: CastType.string,
            )
          : null,
      lastWatch: json.containsKey('last_watch')
          ? ValueHelper.cast(
              value: json['last_watch'],
              type: CastType.int,
            )
          : json.containsKey('last_play')
              ? ValueHelper.cast(
                  value: json['last_play'],
                  type: CastType.int,
                )
              : null,
      mediaIndex: json.containsKey('media_index')
          ? ValueHelper.cast(
              value: json['media_index'],
              type: CastType.int,
            )
          : null,
      mediaType: json.containsKey('media_type')
          ? ValueHelper.cast(
              value: json['media_type'],
              type: CastType.string,
            )
          : null,
      parentMediaIndex: json.containsKey('parent_media_index')
          ? ValueHelper.cast(
              value: json['parent_media_index'],
              type: CastType.int,
            )
          : null,
      platform: json.containsKey('platform')
          ? ValueHelper.cast(
              value: json['platform'],
              type: CastType.string,
            )
          : null,
      platformName: json.containsKey('platform_name')
          ? ValueHelper.cast(
              value: json['platform_name'],
              type: CastType.string,
            )
          : null,
      ratingKey: json.containsKey('rating_key')
          ? ValueHelper.cast(
              value: json['rating_key'],
              type: CastType.int,
            )
          : null,
      rowId: json.containsKey('row_id')
          ? ValueHelper.cast(
              value: json['row_id'],
              type: CastType.int,
            )
          : null,
      sectionId: json.containsKey('section_id')
          ? ValueHelper.cast(
              value: json['section_id'],
              type: CastType.int,
            )
          : null,
      started: json.containsKey('started')
          ? ValueHelper.cast(
              value: json['started'],
              type: CastType.int,
            )
          : null,
      statId: statId,
      thumb: json.containsKey('thumb')
          ? ValueHelper.cast(
              value: json['thumb'],
              type: CastType.string,
            )
          : null,
      title: json.containsKey('title')
          ? ValueHelper.cast(
              value: json['title'],
              type: CastType.string,
            )
          : null,
      totalDuration: json.containsKey('total_duration')
          ? ValueHelper.cast(
              value: json['total_duration'],
              type: CastType.int,
            )
          : null,
      totalPlays: json.containsKey('total_plays')
          ? ValueHelper.cast(
              value: json['total_plays'],
              type: CastType.int,
            )
          : null,
      user: json.containsKey('user')
          ? ValueHelper.cast(
              value: json['user'],
              type: CastType.string,
            )
          : null,
      userId: json.containsKey('user_id')
          ? ValueHelper.cast(
              value: json['user_id'],
              type: CastType.int,
            )
          : null,
      usersWatched: json.containsKey('users_watched')
          ? ValueHelper.cast(
              value: json['users_watched'],
              type: CastType.int,
            )
          : null,
      userThumb: json.containsKey('user_thumb')
          ? ValueHelper.cast(
              value: json['user_thumb'],
              type: CastType.string,
            )
          : null,
      year: json.containsKey('year')
          ? ValueHelper.cast(
              value: json['year'],
              type: CastType.int,
            )
          : null,
    );
  }
}
