// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_table_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserTableModel _$UserTableModelFromJson(Map<String, dynamic> json) =>
    UserTableModel(
      allowGuest: Cast.castToBool(json['allow_guest']),
      doNotify: Cast.castToBool(json['do_notify']),
      duration: Cast.castToInt(json['duration']),
      friendlyName: Cast.castToString(json['friendly_name']),
      username: Cast.castToString(json['username']),
      title: Cast.castToString(json['title']),
      email: Cast.castToString(json['email']),
      guid: Cast.castToString(json['guid']),
      historyRowId: Cast.castToInt(json['history_row_id']),
      ipAddress: Cast.castToString(json['ip_address']),
      isActive: Cast.castToBool(json['is_active']),
      keepHistory: Cast.castToBool(json['keep_history']),
      lastPlayed: Cast.castToString(json['last_played']),
      lastSeen:
          UserTableModel.dateTimeFromEpochSeconds(json['last_seen'] as int?),
      live: Cast.castToBool(json['live']),
      mediaIndex: Cast.castToInt(json['media_index']),
      mediaType: Cast.castStringToMediaType(json['media_type'] as String?),
      originallyAvailableAt: Cast.castToString(json['originally_available_at']),
      parentMediaIndex: Cast.castToInt(json['parent_media_index']),
      parentTitle: Cast.castToString(json['parent_title']),
      platform: Cast.castToString(json['platform']),
      player: Cast.castToString(json['player']),
      plays: Cast.castToInt(json['plays']),
      ratingKey: Cast.castToInt(json['rating_key']),
      rowId: Cast.castToInt(json['row_id']),
      thumb: Cast.castToString(json['thumb']),
      transcodeDecision: Cast.castStringToStreamDecision(
          json['transcode_decision'] as String?),
      userId: Cast.castToInt(json['user_id']),
      userThumb: Cast.castToString(json['user_thumb']),
      year: Cast.castToInt(json['year']),
    );

Map<String, dynamic> _$UserTableModelToJson(UserTableModel instance) =>
    <String, dynamic>{
      'allow_guest': instance.allowGuest,
      'do_notify': instance.doNotify,
      'duration': instance.duration,
      'email': instance.email,
      'friendly_name': instance.friendlyName,
      'guid': instance.guid,
      'history_row_id': instance.historyRowId,
      'ip_address': instance.ipAddress,
      'is_active': instance.isActive,
      'keep_history': instance.keepHistory,
      'last_played': instance.lastPlayed,
      'last_seen': instance.lastSeen?.toIso8601String(),
      'live': instance.live,
      'media_index': instance.mediaIndex,
      'media_type': _$MediaTypeEnumMap[instance.mediaType],
      'originally_available_at': instance.originallyAvailableAt,
      'parent_media_index': instance.parentMediaIndex,
      'parent_title': instance.parentTitle,
      'platform': instance.platform,
      'player': instance.player,
      'plays': instance.plays,
      'rating_key': instance.ratingKey,
      'row_id': instance.rowId,
      'thumb': instance.thumb,
      'title': instance.title,
      'transcode_decision': _$StreamDecisionEnumMap[instance.transcodeDecision],
      'user_id': instance.userId,
      'user_thumb': instance.userThumb,
      'username': instance.username,
      'year': instance.year,
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

const _$StreamDecisionEnumMap = {
  StreamDecision.copy: 'copy',
  StreamDecision.directPlay: 'directPlay',
  StreamDecision.transcode: 'transcode',
  StreamDecision.none: 'none',
  StreamDecision.unknown: 'unknown',
};
