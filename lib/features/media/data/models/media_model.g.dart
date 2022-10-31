// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaModel _$MediaModelFromJson(Map<String, dynamic> json) => MediaModel(
      actors: MediaModel.stringListfromList(json['actors'] as List?),
      addedAt: MediaModel.dateTimeFromEpochSeconds(json['added_at'] as String?),
      audienceRating: Cast.castToDouble(json['audience_rating']),
      collections: MediaModel.stringListfromList(json['collections'] as List?),
      contentRating: Cast.castToString(json['content_rating']),
      directors: MediaModel.stringListfromList(json['directors'] as List?),
      duration:
          MediaModel.durationFromMilliseconds(json['duration'] as String?),
      fullTitle: Cast.castToString(json['full_title']),
      genres: MediaModel.stringListfromList(json['genres'] as List?),
      grandparentRatingKey: Cast.castToInt(json['grandparent_rating_key']),
      grandparentThumb: Cast.castToString(json['grandparent_thumb']),
      grandparentTitle: Cast.castToString(json['grandparent_title']),
      grandparentImageUri: json['grandparentImageUri'] == null
          ? null
          : Uri.parse(json['grandparentImageUri'] as String),
      imageUri: json['imageUri'] == null
          ? null
          : Uri.parse(json['imageUri'] as String),
      labels: MediaModel.stringListfromList(json['labels'] as List?),
      lastViewedAt: MediaModel.dateTimeFromEpochSeconds(
          json['last_viewed_at'] as String?),
      libraryName: Cast.castToString(json['library_name']),
      live: Cast.castToBool(json['live']),
      mediaIndex: Cast.castToInt(json['media_index']),
      mediaInfo: MediaModel.mediaInfoModelFromJson(json['media_info'] as List?),
      mediaType: Cast.castStringToMediaType(json['media_type'] as String?),
      originalTitle: Cast.castToString(json['original_tital']),
      originallyAvailableAt: MediaModel.dateTimeFromString(
          json['originally_available_at'] as String?),
      parentImageUri: json['parentImageUri'] == null
          ? null
          : Uri.parse(json['parentImageUri'] as String),
      parentMediaIndex: Cast.castToInt(json['parent_media_index']),
      parentRatingKey: Cast.castToInt(json['parent_rating_key']),
      parentThumb: Cast.castToString(json['parent_thumb']),
      parentTitle: Cast.castToString(json['parent_title']),
      parentYear: Cast.castToInt(json['parent_year']),
      rating: Cast.castToDouble(json['rating']),
      ratingKey: Cast.castToInt(json['rating_key']),
      sectionId: Cast.castToInt(json['section_id']),
      sortTitle: Cast.castToString(json['sort_title']),
      studio: Cast.castToString(json['studio']),
      summary: Cast.castToString(json['summary']),
      tagline: Cast.castToString(json['tagline']),
      thumb: Cast.castToString(json['thumb']),
      title: Cast.castToString(json['title']),
      updatedAt:
          MediaModel.dateTimeFromEpochSeconds(json['updated_at'] as String?),
      userRating: Cast.castToDouble(json['user_rating']),
      writers: MediaModel.stringListfromList(json['writers'] as List?),
      year: Cast.castToInt(json['year']),
    );

Map<String, dynamic> _$MediaModelToJson(MediaModel instance) =>
    <String, dynamic>{
      'actors': instance.actors,
      'added_at': instance.addedAt?.toIso8601String(),
      'audience_rating': instance.audienceRating,
      'collections': instance.collections,
      'content_rating': instance.contentRating,
      'directors': instance.directors,
      'duration': instance.duration?.inMicroseconds,
      'full_title': instance.fullTitle,
      'genres': instance.genres,
      'grandparent_rating_key': instance.grandparentRatingKey,
      'grandparent_thumb': instance.grandparentThumb,
      'grandparent_title': instance.grandparentTitle,
      'grandparentImageUri': instance.grandparentImageUri?.toString(),
      'imageUri': instance.imageUri?.toString(),
      'labels': instance.labels,
      'last_viewed_at': instance.lastViewedAt?.toIso8601String(),
      'library_name': instance.libraryName,
      'live': instance.live,
      'media_index': instance.mediaIndex,
      'media_info': instance.mediaInfo,
      'media_type': _$MediaTypeEnumMap[instance.mediaType],
      'original_tital': instance.originalTitle,
      'originally_available_at':
          instance.originallyAvailableAt?.toIso8601String(),
      'parentImageUri': instance.parentImageUri?.toString(),
      'parent_media_index': instance.parentMediaIndex,
      'parent_rating_key': instance.parentRatingKey,
      'parent_thumb': instance.parentThumb,
      'parent_title': instance.parentTitle,
      'parent_year': instance.parentYear,
      'rating': instance.rating,
      'rating_key': instance.ratingKey,
      'section_id': instance.sectionId,
      'sort_title': instance.sortTitle,
      'studio': instance.studio,
      'summary': instance.summary,
      'tagline': instance.tagline,
      'thumb': instance.thumb,
      'title': instance.title,
      'updated_at': instance.updatedAt?.toIso8601String(),
      'user_rating': instance.userRating,
      'writers': instance.writers,
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
