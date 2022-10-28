// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistic_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatisticDataModel _$StatisticDataModelFromJson(Map<String, dynamic> json) =>
    StatisticDataModel(
      art: Cast.castToString(json['art']),
      count: Cast.castToInt(json['count']),
      friendlyName: Cast.castToString(json['friendly_name']),
      grandchildTitle: Cast.castToString(json['grandchild_title']),
      grandparentRatingKey: Cast.castToInt(json['grandparent_rating_key']),
      grandparentThumb: Cast.castToString(json['grandparent_thumb']),
      grandparentTitle: Cast.castToString(json['grandparent_title']),
      iconUri:
          json['iconUri'] == null ? null : Uri.parse(json['iconUri'] as String),
      lastPlay: StatisticDataModel.dateTimeFromEpochSeconds(json['last_play']),
      lastWatch:
          StatisticDataModel.dateTimeFromEpochSeconds(json['last_watch']),
      mediaIndex: Cast.castToInt(json['media_index']),
      mediaType: Cast.castStringToMediaType(json['media_type'] as String?),
      parentMediaIndex: Cast.castToInt(json['parent_media_index']),
      platform: Cast.castToString(json['platform']),
      platformName: Cast.castToString(json['platform_name']),
      posterUri: json['posterUri'] == null
          ? null
          : Uri.parse(json['posterUri'] as String),
      ratingKey: Cast.castToInt(json['rating_key']),
      rowId: Cast.castToInt(json['row_id']),
      sectionId: Cast.castToInt(json['section_id']),
      sectionName: Cast.castToString(json['section_name']),
      sectionType:
          Cast.castStringToSectionType(json['section_type'] as String?),
      started: StatisticDataModel.dateTimeFromEpochSeconds(json['started']),
      thumb: Cast.castToString(json['thumb']),
      title: Cast.castToString(json['title']),
      totalDuration:
          StatisticDataModel.durationFromJson(json['total_duration'] as int?),
      totalPlays: Cast.castToInt(json['total_plays']),
      user: Cast.castToString(json['user']),
      userId: Cast.castToInt(json['user_id']),
      usersWatched: Cast.castToInt(json['users_watched']),
      userThumb: Cast.castToString(json['user_thumb']),
      year: Cast.castToInt(json['year']),
    );

Map<String, dynamic> _$StatisticDataModelToJson(StatisticDataModel instance) =>
    <String, dynamic>{
      'art': instance.art,
      'count': instance.count,
      'friendly_name': instance.friendlyName,
      'grandchild_title': instance.grandchildTitle,
      'grandparent_rating_key': instance.grandparentRatingKey,
      'grandparent_thumb': instance.grandparentThumb,
      'grandparent_title': instance.grandparentTitle,
      'iconUri': instance.iconUri?.toString(),
      'last_play': instance.lastPlay?.toIso8601String(),
      'last_watch': instance.lastWatch?.toIso8601String(),
      'media_index': instance.mediaIndex,
      'media_type': _$MediaTypeEnumMap[instance.mediaType],
      'parent_media_index': instance.parentMediaIndex,
      'platform': instance.platform,
      'platform_name': instance.platformName,
      'posterUri': instance.posterUri?.toString(),
      'rating_key': instance.ratingKey,
      'row_id': instance.rowId,
      'section_id': instance.sectionId,
      'section_name': instance.sectionName,
      'section_type': _$SectionTypeEnumMap[instance.sectionType],
      'started': instance.started?.toIso8601String(),
      'thumb': instance.thumb,
      'title': instance.title,
      'total_duration': instance.totalDuration?.inMicroseconds,
      'total_plays': instance.totalPlays,
      'user': instance.user,
      'user_id': instance.userId,
      'users_watched': instance.usersWatched,
      'user_thumb': instance.userThumb,
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

const _$SectionTypeEnumMap = {
  SectionType.artist: 'artist',
  SectionType.movie: 'movie',
  SectionType.live: 'live',
  SectionType.photo: 'photo',
  SectionType.playlist: 'playlist',
  SectionType.show: 'show',
  SectionType.video: 'video',
  SectionType.unknown: 'unknown',
};
