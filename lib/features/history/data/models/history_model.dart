import '../../../../core/helpers/value_helper.dart';
import '../../domain/entities/history.dart';

class HistoryModel extends History {
  HistoryModel({
    final int date,
    final int duration,
    final String friendlyName,
    final String fullTitle,
    final int grandparentRatingKey,
    final String grandparentTitle,
    final int groupCount,
    final List<int> groupIds,
    final int id,
    final String ipAddress,
    final int live,
    final int mediaIndex,
    final String mediaType,
    final int parentMediaIndex,
    final int parentRatingKey,
    final String parentTitle,
    final int pausedCounter,
    final int percentComplete,
    final String platform,
    final String player,
    final String product,
    final int ratingKey,
    final int sessionKey,
    final int started,
    final String state,
    final int stopped,
    final String title,
    final String thumb,
    final String transcodeDecision,
    final String user,
    final int userId,
    final num watchedStatus,
    final int year,
    String posterUrl,
  }) : super(
          date: date,
          duration: duration,
          friendlyName: friendlyName,
          fullTitle: fullTitle,
          grandparentRatingKey: grandparentRatingKey,
          grandparentTitle: grandparentTitle,
          groupCount: groupCount,
          groupIds: groupIds,
          id: id,
          ipAddress: ipAddress,
          live: live,
          mediaIndex: mediaIndex,
          mediaType: mediaType,
          parentMediaIndex: parentMediaIndex,
          parentRatingKey: parentRatingKey,
          parentTitle: parentTitle,
          pausedCounter: pausedCounter,
          percentComplete: percentComplete,
          platform: platform,
          player: player,
          product: product,
          ratingKey: ratingKey,
          sessionKey: sessionKey,
          started: started,
          state: state,
          stopped: stopped,
          title: title,
          thumb: thumb,
          transcodeDecision: transcodeDecision,
          user: user,
          userId: userId,
          watchedStatus: watchedStatus,
          year: year,
          posterUrl: posterUrl,
        );

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    List<int> groupIds = [];
    json['group_ids']?.split(',')?.forEach((id) => groupIds.add(int.parse(id)));

    return HistoryModel(
      date: ValueHelper.cast(
        value: json['date'],
        type: CastType.int,
      ),
      duration: ValueHelper.cast(
        value: json['duration'],
        type: CastType.int,
      ),
      friendlyName: ValueHelper.cast(
        value: json['friendly_name'],
        type: CastType.string,
      ),
      fullTitle: ValueHelper.cast(
        value: json['full_title'],
        type: CastType.string,
      ),
      grandparentRatingKey: ValueHelper.cast(
        value: json['grandparent_rating_key'],
        type: CastType.int,
      ),
      grandparentTitle: ValueHelper.cast(
        value: json['grandparent_title'],
        type: CastType.string,
      ),
      groupCount: ValueHelper.cast(
        value: json['group_count'],
        type: CastType.int,
      ),
      groupIds: groupIds,
      id: ValueHelper.cast(
        value: json['id'],
        type: CastType.int,
      ),
      ipAddress: ValueHelper.cast(
        value: json['ip_address'],
        type: CastType.string,
      ),
      live: ValueHelper.cast(
        value: json['live'],
        type: CastType.int,
      ),
      mediaIndex: ValueHelper.cast(
        value: json['media_index'],
        type: CastType.int,
      ),
      mediaType: ValueHelper.cast(
        value: json['media_type'],
        type: CastType.string,
      ),
      parentMediaIndex: ValueHelper.cast(
        value: json['parent_media_index'],
        type: CastType.int,
      ),
      parentRatingKey: ValueHelper.cast(
        value: json['parent_rating_key'],
        type: CastType.int,
      ),
      parentTitle: ValueHelper.cast(
        value: json['parent_title'],
        type: CastType.string,
      ),
      pausedCounter: ValueHelper.cast(
        value: json['paused_counter'],
        type: CastType.int,
      ),
      percentComplete: ValueHelper.cast(
        value: json['percent_complete'],
        type: CastType.int,
      ),
      platform: ValueHelper.cast(
        value: json['platform'],
        type: CastType.string,
      ),
      player: ValueHelper.cast(
        value: json['player'],
        type: CastType.string,
      ),
      product: ValueHelper.cast(
        value: json['product'],
        type: CastType.string,
      ),
      ratingKey: ValueHelper.cast(
        value: json['rating_key'],
        type: CastType.int,
      ),
      sessionKey: ValueHelper.cast(
        value: json['session_key'],
        type: CastType.int,
      ),
      started: ValueHelper.cast(
        value: json['started'],
        type: CastType.int,
      ),
      state: ValueHelper.cast(
        value: json['state'],
        type: CastType.string,
      ),
      stopped: ValueHelper.cast(
        value: json['stopped'],
        type: CastType.int,
      ),
      title: ValueHelper.cast(
        value: json['title'],
        type: CastType.string,
      ),
      thumb: ValueHelper.cast(
        value: json['thumb'],
        type: CastType.string,
      ),
      transcodeDecision: ValueHelper.cast(
        value: json['transcode_decision'],
        type: CastType.string,
      ),
      user: ValueHelper.cast(
        value: json['user'],
        type: CastType.string,
      ),
      userId: ValueHelper.cast(
        value: json['user_id'],
        type: CastType.int,
      ),
      watchedStatus: ValueHelper.cast(
        value: json['watched_status'],
        type: CastType.num,
      ),
      year: ValueHelper.cast(
        value: json['year'],
        type: CastType.int,
      ),
    );
  }
}
