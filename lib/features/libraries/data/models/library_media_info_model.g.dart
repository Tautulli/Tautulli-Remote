// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_media_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LibraryMediaInfoModel _$LibraryMediaInfoModelFromJson(
        Map<String, dynamic> json) =>
    LibraryMediaInfoModel(
      addedAt: LibraryMediaInfoModel.dateTimeFromStringEpochSeconds(
          json['added_at'] as String?),
      grandparentRatingKey: Cast.castToInt(json['grandparent_rating_key']),
      lastPlayed: LibraryMediaInfoModel.dateTimeFromEpochSeconds(
          json['last_played'] as int?),
      mediaIndex: Cast.castToInt(json['media_index']),
      mediaType: Cast.castStringToMediaType(json['media_type'] as String?),
      parentMediaIndex: Cast.castToInt(json['parent_media_index']),
      parentRatingKey: Cast.castToInt(json['parent_rating_key']),
      playCount: Cast.castToInt(json['play_count']),
      posterUri: json['posterUri'] == null
          ? null
          : Uri.parse(json['posterUri'] as String),
      sectionId: Cast.castToInt(json['section_id']),
      sectionType:
          Cast.castStringToSectionType(json['section_type'] as String?),
      ratingKey: Cast.castToInt(json['rating_key']),
      sortTitle: Cast.castToString(json['sort_title']),
      thumb: Cast.castToString(json['thumb']),
      title: Cast.castToString(json['title']),
      year: Cast.castToInt(json['year']),
    );

Map<String, dynamic> _$LibraryMediaInfoModelToJson(
        LibraryMediaInfoModel instance) =>
    <String, dynamic>{
      'added_at': instance.addedAt?.toIso8601String(),
      'grandparent_rating_key': instance.grandparentRatingKey,
      'last_played': instance.lastPlayed?.toIso8601String(),
      'media_index': instance.mediaIndex,
      'media_type': _$MediaTypeEnumMap[instance.mediaType],
      'parent_media_index': instance.parentMediaIndex,
      'parent_rating_key': instance.parentRatingKey,
      'play_count': instance.playCount,
      'posterUri': instance.posterUri?.toString(),
      'section_id': instance.sectionId,
      'section_type': _$SectionTypeEnumMap[instance.sectionType],
      'rating_key': instance.ratingKey,
      'sort_title': instance.sortTitle,
      'thumb': instance.thumb,
      'title': instance.title,
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
