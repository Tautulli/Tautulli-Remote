import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/types/media_type.dart';
import '../../../../core/utilities/cast.dart';

part 'recently_added_model.g.dart';

@JsonSerializable()
class RecentlyAddedModel extends Equatable {
  @JsonKey(name: 'actors', fromJson: stringListfromList)
  final List<String>? actors;
  @JsonKey(name: 'added_at', fromJson: dateTimeFromEpochSeconds)
  final DateTime? addedAt;
  @JsonKey(name: 'art', fromJson: Cast.castToString)
  final String? art;
  @JsonKey(name: 'audience_rating', fromJson: Cast.castToNum)
  final num? audienceRating;
  @JsonKey(name: 'audience_rating_image', fromJson: Cast.castToString)
  final String? audienceRatingImage;
  @JsonKey(name: 'banner', fromJson: Cast.castToString)
  final String? banner;
  @JsonKey(name: 'child_count', fromJson: Cast.castToInt)
  final int? childCount;
  @JsonKey(name: 'directors', fromJson: stringListfromList)
  final List<String>? directors;
  @JsonKey(name: 'duration', fromJson: durationFromJson)
  final Duration? duration;
  @JsonKey(name: 'full_title', fromJson: Cast.castToString)
  final String? fullTitle;
  @JsonKey(name: 'genres', fromJson: stringListfromList)
  final List<String>? genres;
  final Uri? grandparentPosterUri;
  @JsonKey(name: 'grandparent_rating_key', fromJson: Cast.castToInt)
  final int? grandparentRatingKey;
  @JsonKey(name: 'grandparent_thumb', fromJson: Cast.castToString)
  final String? grandparentThumb;
  @JsonKey(name: 'grandparent_title', fromJson: Cast.castToString)
  final String? grandparentTitle;
  @JsonKey(name: 'guid', fromJson: Cast.castToString)
  final String? guid;
  @JsonKey(name: 'guids', fromJson: stringListfromList)
  final List<String>? guids;
  @JsonKey(name: 'labels', fromJson: stringListfromList)
  final List<String>? labels;
  @JsonKey(name: 'last_viewed_at', fromJson: dateTimeFromEpochSeconds)
  final DateTime? lastViewedAt;
  @JsonKey(name: 'library_name', fromJson: Cast.castToString)
  final String? libraryName;
  @JsonKey(name: 'media_index', fromJson: Cast.castToInt)
  final int? mediaIndex;
  @JsonKey(name: 'media_type', fromJson: Cast.castStringToMediaType)
  final MediaType? mediaType;
  @JsonKey(name: 'original_title', fromJson: Cast.castToString)
  final String? originalTitle;
  @JsonKey(name: 'originally_available_at', fromJson: dateTimeFromString)
  final DateTime? originallyAvailableAt;
  @JsonKey(name: 'parent_media_index', fromJson: Cast.castToInt)
  final int? parentMediaIndex;
  final Uri? parentPosterUri;
  @JsonKey(name: 'parent_rating_key', fromJson: Cast.castToInt)
  final int? parentRatingKey;
  @JsonKey(name: 'parent_thumb', fromJson: Cast.castToString)
  final String? parentThumb;
  @JsonKey(name: 'parent_title', fromJson: Cast.castToString)
  final String? parentTitle;
  final Uri? posterUri;
  @JsonKey(name: 'rating', fromJson: Cast.castToNum)
  final num? rating;
  @JsonKey(name: 'rating_image', fromJson: Cast.castToString)
  final String? ratingImage;
  @JsonKey(name: 'rating_key', fromJson: Cast.castToInt)
  final int? ratingKey;
  @JsonKey(name: 'section_id', fromJson: Cast.castToInt)
  final int? sectionId;
  @JsonKey(name: 'sort_title', fromJson: Cast.castToString)
  final String? sortTitle;
  @JsonKey(name: 'studio', fromJson: Cast.castToString)
  final String? studio;
  @JsonKey(name: 'summary', fromJson: Cast.castToString)
  final String? summary;
  @JsonKey(name: 'tagline', fromJson: Cast.castToString)
  final String? tagline;
  @JsonKey(name: 'thumb', fromJson: Cast.castToString)
  final String? thumb;
  @JsonKey(name: 'title', fromJson: Cast.castToString)
  final String? title;
  @JsonKey(name: 'user_rating', fromJson: Cast.castToNum)
  final num? userRating;
  @JsonKey(name: 'updated_at', fromJson: dateTimeFromEpochSeconds)
  final DateTime? updatedAt;
  @JsonKey(name: 'writers', fromJson: stringListfromList)
  final List<String>? writers;
  @JsonKey(name: 'year', fromJson: Cast.castToInt)
  final int? year;

  const RecentlyAddedModel({
    this.actors,
    this.addedAt,
    this.art,
    this.audienceRating,
    this.audienceRatingImage,
    this.banner,
    this.childCount,
    this.directors,
    this.duration,
    this.fullTitle,
    this.genres,
    this.grandparentPosterUri,
    this.grandparentRatingKey,
    this.grandparentThumb,
    this.grandparentTitle,
    this.guid,
    this.guids,
    this.labels,
    this.lastViewedAt,
    this.libraryName,
    this.mediaIndex,
    this.mediaType,
    this.originalTitle,
    this.originallyAvailableAt,
    this.parentMediaIndex,
    this.parentPosterUri,
    this.parentRatingKey,
    this.parentThumb,
    this.parentTitle,
    this.posterUri,
    this.rating,
    this.ratingImage,
    this.ratingKey,
    this.sectionId,
    this.sortTitle,
    this.studio,
    this.summary,
    this.tagline,
    this.thumb,
    this.title,
    this.userRating,
    this.updatedAt,
    this.writers,
    this.year,
  });

  RecentlyAddedModel copyWith({
    final List<String>? actors,
    final DateTime? addedAt,
    final String? art,
    final num? audienceRating,
    final String? audienceRatingImage,
    final String? banner,
    final int? childCount,
    final List<String>? directors,
    final Duration? duration,
    final String? fullTitle,
    final List<String>? genres,
    final Uri? grandparentPosterUri,
    final int? grandparentRatingKey,
    final String? grandparentThumb,
    final String? grandparentTitle,
    final String? guid,
    final List<String>? guids,
    final List<String>? labels,
    final DateTime? lastViewedAt,
    final String? libraryName,
    final int? mediaIndex,
    final MediaType? mediaType,
    final String? originalTitle,
    final DateTime? originallyAvailableAt,
    final int? parentMediaIndex,
    final Uri? parentPosterUri,
    final int? parentRatingKey,
    final String? parentThumb,
    final String? parentTitle,
    final Uri? posterUri,
    final num? rating,
    final String? ratingImage,
    final int? ratingKey,
    final int? sectionId,
    final String? sortTitle,
    final String? studio,
    final String? summary,
    final String? tagline,
    final String? thumb,
    final String? title,
    final num? userRating,
    final DateTime? updatedAt,
    final List<String>? writers,
    final int? year,
  }) {
    return RecentlyAddedModel(
      actors: actors ?? this.actors,
      addedAt: addedAt ?? this.addedAt,
      art: art ?? this.art,
      audienceRating: audienceRating ?? this.audienceRating,
      audienceRatingImage: audienceRatingImage ?? this.audienceRatingImage,
      banner: banner ?? this.banner,
      childCount: childCount ?? this.childCount,
      directors: directors ?? this.directors,
      duration: duration ?? this.duration,
      fullTitle: fullTitle ?? this.fullTitle,
      genres: genres ?? this.genres,
      grandparentPosterUri: grandparentPosterUri ?? this.grandparentPosterUri,
      grandparentRatingKey: grandparentRatingKey ?? this.grandparentRatingKey,
      grandparentThumb: grandparentThumb ?? this.grandparentThumb,
      grandparentTitle: grandparentTitle ?? this.grandparentTitle,
      guid: guid ?? this.guid,
      guids: guids ?? this.guids,
      labels: labels ?? this.labels,
      lastViewedAt: lastViewedAt ?? this.lastViewedAt,
      libraryName: libraryName ?? this.libraryName,
      mediaIndex: mediaIndex ?? this.mediaIndex,
      mediaType: mediaType ?? this.mediaType,
      originalTitle: originalTitle ?? this.originalTitle,
      originallyAvailableAt: originallyAvailableAt ?? this.originallyAvailableAt,
      parentMediaIndex: parentMediaIndex ?? this.parentMediaIndex,
      parentPosterUri: parentPosterUri ?? this.parentPosterUri,
      parentRatingKey: parentRatingKey ?? this.parentRatingKey,
      parentThumb: parentThumb ?? this.parentThumb,
      parentTitle: parentTitle ?? this.parentTitle,
      posterUri: posterUri ?? this.posterUri,
      rating: rating ?? this.rating,
      ratingImage: ratingImage ?? this.ratingImage,
      ratingKey: ratingKey ?? this.ratingKey,
      sectionId: sectionId ?? this.sectionId,
      sortTitle: sortTitle ?? this.sortTitle,
      studio: studio ?? this.studio,
      summary: summary ?? this.summary,
      tagline: tagline ?? this.tagline,
      thumb: thumb ?? this.thumb,
      title: title ?? this.title,
      userRating: userRating ?? this.userRating,
      updatedAt: updatedAt ?? this.updatedAt,
      writers: writers ?? this.writers,
      year: year ?? this.year,
    );
  }

  factory RecentlyAddedModel.fromJson(Map<String, dynamic> json) => _$RecentlyAddedModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecentlyAddedModelToJson(this);

  static List<String>? stringListfromList(List? list) {
    if (list == null) return [];

    return list.map((item) => item.toString()).toList();
  }

  static DateTime? dateTimeFromString(String? date) {
    if (date == null) return null;
    return DateTime.tryParse(date);
  }

  static DateTime? dateTimeFromEpochSeconds(String? secondsSinceEpochString) {
    final secondsSinceEpoch = Cast.castToInt(secondsSinceEpochString);

    if (secondsSinceEpoch == null) return null;

    return DateTime.fromMillisecondsSinceEpoch((secondsSinceEpoch) * 1000);
  }

  static Duration? durationFromJson(String? secondsString) {
    final seconds = Cast.castToInt(secondsString);

    if (seconds == null) return null;

    return Duration(seconds: seconds);
  }

  @override
  List<Object?> get props => [
        actors,
        addedAt,
        art,
        audienceRating,
        audienceRatingImage,
        banner,
        childCount,
        directors,
        duration,
        fullTitle,
        genres,
        grandparentPosterUri,
        grandparentRatingKey,
        grandparentThumb,
        grandparentTitle,
        guid,
        guids,
        labels,
        lastViewedAt,
        libraryName,
        mediaIndex,
        mediaType,
        originalTitle,
        originallyAvailableAt,
        parentMediaIndex,
        parentPosterUri,
        parentRatingKey,
        parentThumb,
        parentTitle,
        posterUri,
        rating,
        ratingImage,
        ratingKey,
        sectionId,
        sortTitle,
        studio,
        summary,
        tagline,
        thumb,
        title,
        userRating,
        updatedAt,
        writers,
        year,
      ];
}
