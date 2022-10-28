// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_table_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LibraryTableModel _$LibraryTableModelFromJson(Map<String, dynamic> json) =>
    LibraryTableModel(
      backgroundUri: json['backgroundUri'] == null
          ? null
          : Uri.parse(json['backgroundUri'] as String),
      childCount: Cast.castToInt(json['child_count']),
      contentRating: Cast.castToString(json['content_rating']),
      count: Cast.castToInt(json['count']),
      doNotify: Cast.castToBool(json['do_notify']),
      doNotifyCreated: Cast.castToBool(json['do_notify_created']),
      duration: LibraryTableModel.durationFromSeconds(json['duration'] as int?),
      guid: Cast.castToString(json['guid']),
      historyRow: Cast.castToInt(json['history_row']),
      iconUri:
          json['iconUri'] == null ? null : Uri.parse(json['iconUri'] as String),
      isActive: Cast.castToBool(json['is_active']),
      keepHistory: Cast.castToBool(json['keep_history']),
      labels:
          (json['labels'] as List<dynamic>?)?.map((e) => e as String).toList(),
      lastAccessed: LibraryTableModel.dateTimeFromEpochSeconds(
          json['last_accessed'] as int?),
      lastPlayed: Cast.castToString(json['last_played']),
      libraryArt: Cast.castToString(json['library_art']),
      libraryThumb: Cast.castToString(json['library_thumb']),
      live: Cast.castToBool(json['live']),
      mediaIndex: Cast.castToInt(json['media_index']),
      mediaType: Cast.castStringToMediaType(json['media_type'] as String?),
      originallyAvailableAt: LibraryTableModel.dateTimeFromString(
          json['originally_available_at'] as String?),
      parentCount: Cast.castToInt(json['parent_count']),
      parentMediaIndex: Cast.castToInt(json['parent_media_index']),
      parentTitle: Cast.castToString(json['parent_title']),
      plays: Cast.castToInt(json['plays']),
      ratingKey: Cast.castToInt(json['rating_key']),
      rowId: Cast.castToInt(json['row_id']),
      sectionId: Cast.castToInt(json['section_id']),
      sectionName: Cast.castToString(json['section_name']),
      sectionType:
          Cast.castStringToSectionType(json['section_type'] as String?),
      serverId: Cast.castToString(json['server_id']),
      thumb: Cast.castToString(json['thumb']),
      year: Cast.castToInt(json['year']),
    );

Map<String, dynamic> _$LibraryTableModelToJson(LibraryTableModel instance) =>
    <String, dynamic>{
      'backgroundUri': instance.backgroundUri?.toString(),
      'child_count': instance.childCount,
      'content_rating': instance.contentRating,
      'count': instance.count,
      'do_notify': instance.doNotify,
      'do_notify_created': instance.doNotifyCreated,
      'duration': instance.duration?.inMicroseconds,
      'guid': instance.guid,
      'history_row': instance.historyRow,
      'iconUri': instance.iconUri?.toString(),
      'is_active': instance.isActive,
      'keep_history': instance.keepHistory,
      'labels': instance.labels,
      'last_accessed': instance.lastAccessed?.toIso8601String(),
      'last_played': instance.lastPlayed,
      'library_art': instance.libraryArt,
      'library_thumb': instance.libraryThumb,
      'live': instance.live,
      'media_index': instance.mediaIndex,
      'media_type': _$MediaTypeEnumMap[instance.mediaType],
      'originally_available_at':
          instance.originallyAvailableAt?.toIso8601String(),
      'parent_count': instance.parentCount,
      'parent_media_index': instance.parentMediaIndex,
      'parent_title': instance.parentTitle,
      'plays': instance.plays,
      'rating_key': instance.ratingKey,
      'row_id': instance.rowId,
      'section_id': instance.sectionId,
      'section_name': instance.sectionName,
      'section_type': _$SectionTypeEnumMap[instance.sectionType],
      'server_id': instance.serverId,
      'thumb': instance.thumb,
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
