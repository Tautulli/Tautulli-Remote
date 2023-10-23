// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryModel _$HistoryModelFromJson(Map<String, dynamic> json) => HistoryModel(
      date: HistoryModel.dateTimeFromEpochSeconds(json['date'] as int?),
      duration: HistoryModel.durationFromJson(json['duration'] as int?),
      friendlyName: Cast.castToString(json['friendly_name']),
      fullTitle: Cast.castToString(json['full_title']),
      grandparentRatingKey: Cast.castToInt(json['grandparent_rating_key']),
      grandparentTitle: Cast.castToString(json['grandparent_title']),
      groupCount: Cast.castToInt(json['group_count']),
      groupIds: HistoryModel.groupIdsFromJson(json['group_ids'] as String?),
      guid: Cast.castToString(json['guid']),
      id: Cast.castToInt(json['id']),
      ipAddress: Cast.castToString(json['ip_address']),
      live: Cast.castToBool(json['live']),
      location: Cast.castStringToLocation(json['location'] as String?),
      machineId: Cast.castToString(json['machine_id']),
      mediaIndex: Cast.castToInt(json['media_index']),
      mediaType: Cast.castStringToMediaType(json['media_type'] as String?),
      originallyAvailableAt: HistoryModel.dateTimeFromString(
          json['originally_available_at'] as String?),
      originalTitle: Cast.castToString(json['original_title']),
      parentMediaIndex: Cast.castToInt(json['parent_media_index']),
      parentRatingKey: Cast.castToInt(json['parent_rating_key']),
      parentTitle: Cast.castToString(json['parent_title']),
      pausedCounter:
          HistoryModel.durationFromJson(json['paused_counter'] as int?),
      percentComplete: Cast.castToInt(json['percent_complete']),
      platform: Cast.castToString(json['platform']),
      player: Cast.castToString(json['player']),
      posterUri: json['posterUri'] == null
          ? null
          : Uri.parse(json['posterUri'] as String),
      product: Cast.castToString(json['product']),
      ratingKey: Cast.castToInt(json['rating_key']),
      referenceId: Cast.castToInt(json['reference_id']),
      relayed: Cast.castToBool(json['relayed']),
      rowId: Cast.castToInt(json['row_id']),
      secure: Cast.castToBool(json['secure']),
      sessionKey: Cast.castToInt(json['session_key']),
      started: HistoryModel.dateTimeFromEpochSeconds(json['started'] as int?),
      state: Cast.castStringToPlaybackState(json['state'] as String?),
      stopped: HistoryModel.dateTimeFromEpochSeconds(json['stopped'] as int?),
      thumb: Cast.castToString(json['thumb']),
      title: Cast.castToString(json['title']),
      transcodeDecision: Cast.castStringToStreamDecision(
          json['transcode_decision'] as String?),
      user: Cast.castToString(json['user']),
      userId: Cast.castToInt(json['user_id']),
      userThumb: Cast.castToString(json['user_thumb']),
      watchedStatus:
          HistoryModel.watchedStatusFromDouble(json['watched_status'] as num),
      year: Cast.castToInt(json['year']),
    );

Map<String, dynamic> _$HistoryModelToJson(HistoryModel instance) =>
    <String, dynamic>{
      'date': instance.date?.toIso8601String(),
      'duration': instance.duration?.inMicroseconds,
      'friendly_name': instance.friendlyName,
      'full_title': instance.fullTitle,
      'grandparent_rating_key': instance.grandparentRatingKey,
      'grandparent_title': instance.grandparentTitle,
      'group_count': instance.groupCount,
      'group_ids': instance.groupIds,
      'guid': instance.guid,
      'id': instance.id,
      'ip_address': instance.ipAddress,
      'live': instance.live,
      'location': _$LocationEnumMap[instance.location],
      'machine_id': instance.machineId,
      'media_index': instance.mediaIndex,
      'media_type': _$MediaTypeEnumMap[instance.mediaType],
      'originally_available_at':
          instance.originallyAvailableAt?.toIso8601String(),
      'original_title': instance.originalTitle,
      'parent_media_index': instance.parentMediaIndex,
      'parent_rating_key': instance.parentRatingKey,
      'parent_title': instance.parentTitle,
      'paused_counter': instance.pausedCounter?.inMicroseconds,
      'percent_complete': instance.percentComplete,
      'platform': instance.platform,
      'player': instance.player,
      'posterUri': instance.posterUri?.toString(),
      'product': instance.product,
      'rating_key': instance.ratingKey,
      'reference_id': instance.referenceId,
      'relayed': instance.relayed,
      'row_id': instance.rowId,
      'secure': instance.secure,
      'session_key': instance.sessionKey,
      'started': instance.started?.toIso8601String(),
      'state': _$PlaybackStateEnumMap[instance.state],
      'stopped': instance.stopped?.toIso8601String(),
      'thumb': instance.thumb,
      'title': instance.title,
      'transcode_decision': _$StreamDecisionEnumMap[instance.transcodeDecision],
      'user': instance.user,
      'user_id': instance.userId,
      'user_thumb': instance.userThumb,
      'watched_status': _$WatchedStatusEnumMap[instance.watchedStatus],
      'year': instance.year,
    };

const _$LocationEnumMap = {
  Location.cellular: 'cellular',
  Location.lan: 'lan',
  Location.wan: 'wan',
  Location.unknown: 'unknown',
};

const _$MediaTypeEnumMap = {
  MediaType.album: 'album',
  MediaType.artist: 'artist',
  MediaType.clip: 'clip',
  MediaType.collection: 'collection',
  MediaType.episode: 'episode',
  MediaType.movie: 'movie',
  MediaType.otherVideo: 'otherVideo',
  MediaType.photo: 'photo',
  MediaType.photoAlbum: 'photoAlbum',
  MediaType.playlist: 'playlist',
  MediaType.season: 'season',
  MediaType.show: 'show',
  MediaType.track: 'track',
  MediaType.unknown: 'unknown',
};

const _$PlaybackStateEnumMap = {
  PlaybackState.buffering: 'buffering',
  PlaybackState.error: 'error',
  PlaybackState.paused: 'paused',
  PlaybackState.playing: 'playing',
  PlaybackState.unknown: 'unknown',
};

const _$StreamDecisionEnumMap = {
  StreamDecision.copy: 'copy',
  StreamDecision.directPlay: 'directPlay',
  StreamDecision.transcode: 'transcode',
  StreamDecision.none: 'none',
  StreamDecision.unknown: 'unknown',
};

const _$WatchedStatusEnumMap = {
  WatchedStatus.empty: 'empty',
  WatchedStatus.quarter: 'quarter',
  WatchedStatus.half: 'half',
  WatchedStatus.threeQuarter: 'threeQuarter',
  WatchedStatus.full: 'full',
};
