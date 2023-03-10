// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recently_added_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecentlyAddedModel _$RecentlyAddedModelFromJson(Map<String, dynamic> json) =>
    RecentlyAddedModel(
      actors: RecentlyAddedModel.stringListfromList(json['actors'] as List?),
      addedAt: RecentlyAddedModel.dateTimeFromEpochSeconds(
          json['added_at'] as String?),
      art: Cast.castToString(json['art']),
      audienceRating: Cast.castToNum(json['audience_rating']),
      audienceRatingImage: Cast.castToString(json['audience_rating_image']),
      banner: Cast.castToString(json['banner']),
      childCount: Cast.castToInt(json['child_count']),
      directors:
          RecentlyAddedModel.stringListfromList(json['directors'] as List?),
      duration:
          RecentlyAddedModel.durationFromJson(json['duration'] as String?),
      fullTitle: Cast.castToString(json['full_title']),
      genres: RecentlyAddedModel.stringListfromList(json['genres'] as List?),
      grandparentPosterUri: json['grandparentPosterUri'] == null
          ? null
          : Uri.parse(json['grandparentPosterUri'] as String),
      grandparentRatingKey: Cast.castToInt(json['grandparent_rating_key']),
      grandparentThumb: Cast.castToString(json['grandparent_thumb']),
      grandparentTitle: Cast.castToString(json['grandparent_title']),
      guid: Cast.castToString(json['guid']),
      guids: RecentlyAddedModel.stringListfromList(json['guids'] as List?),
      labels: RecentlyAddedModel.stringListfromList(json['labels'] as List?),
      lastViewedAt: RecentlyAddedModel.dateTimeFromEpochSeconds(
          json['last_viewed_at'] as String?),
      libraryName: Cast.castToString(json['library_name']),
      mediaIndex: Cast.castToInt(json['media_index']),
      mediaType: Cast.castStringToMediaType(json['media_type'] as String?),
      originalTitle: Cast.castToString(json['original_title']),
      originallyAvailableAt: RecentlyAddedModel.dateTimeFromString(
          json['originally_available_at'] as String?),
      parentMediaIndex: Cast.castToInt(json['parent_media_index']),
      parentPosterUri: json['parentPosterUri'] == null
          ? null
          : Uri.parse(json['parentPosterUri'] as String),
      parentRatingKey: Cast.castToInt(json['parent_rating_key']),
      parentThumb: Cast.castToString(json['parent_thumb']),
      parentTitle: Cast.castToString(json['parent_title']),
      posterUri: json['posterUri'] == null
          ? null
          : Uri.parse(json['posterUri'] as String),
      rating: Cast.castToNum(json['rating']),
      ratingImage: Cast.castToString(json['rating_image']),
      ratingKey: Cast.castToInt(json['rating_key']),
      sectionId: Cast.castToInt(json['section_id']),
      sortTitle: Cast.castToString(json['sort_title']),
      studio: Cast.castToString(json['studio']),
      summary: Cast.castToString(json['summary']),
      tagline: Cast.castToString(json['tagline']),
      thumb: Cast.castToString(json['thumb']),
      title: Cast.castToString(json['title']),
      userRating: Cast.castToNum(json['user_rating']),
      updatedAt: RecentlyAddedModel.dateTimeFromEpochSeconds(
          json['updated_at'] as String?),
      writers: RecentlyAddedModel.stringListfromList(json['writers'] as List?),
      year: Cast.castToInt(json['year']),
    );

Map<String, dynamic> _$RecentlyAddedModelToJson(RecentlyAddedModel instance) =>
    <String, dynamic>{
      'actors': instance.actors,
      'added_at': instance.addedAt?.toIso8601String(),
      'art': instance.art,
      'audience_rating': instance.audienceRating,
      'audience_rating_image': instance.audienceRatingImage,
      'banner': instance.banner,
      'child_count': instance.childCount,
      'directors': instance.directors,
      'duration': instance.duration?.inMicroseconds,
      'full_title': instance.fullTitle,
      'genres': instance.genres,
      'grandparentPosterUri': instance.grandparentPosterUri?.toString(),
      'grandparent_rating_key': instance.grandparentRatingKey,
      'grandparent_thumb': instance.grandparentThumb,
      'grandparent_title': instance.grandparentTitle,
      'guid': instance.guid,
      'guids': instance.guids,
      'labels': instance.labels,
      'last_viewed_at': instance.lastViewedAt?.toIso8601String(),
      'library_name': instance.libraryName,
      'media_index': instance.mediaIndex,
      'media_type': _$MediaTypeEnumMap[instance.mediaType],
      'original_title': instance.originalTitle,
      'originally_available_at':
          instance.originallyAvailableAt?.toIso8601String(),
      'parent_media_index': instance.parentMediaIndex,
      'parentPosterUri': instance.parentPosterUri?.toString(),
      'parent_rating_key': instance.parentRatingKey,
      'parent_thumb': instance.parentThumb,
      'parent_title': instance.parentTitle,
      'posterUri': instance.posterUri?.toString(),
      'rating': instance.rating,
      'rating_image': instance.ratingImage,
      'rating_key': instance.ratingKey,
      'section_id': instance.sectionId,
      'sort_title': instance.sortTitle,
      'studio': instance.studio,
      'summary': instance.summary,
      'tagline': instance.tagline,
      'thumb': instance.thumb,
      'title': instance.title,
      'user_rating': instance.userRating,
      'updated_at': instance.updatedAt?.toIso8601String(),
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
