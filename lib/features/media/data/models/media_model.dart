import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/types/media_type.dart';
import '../../../../core/utilities/cast.dart';
import 'media_info_model.dart';

part 'media_model.g.dart';

@JsonSerializable()
class MediaModel extends Equatable {
  @JsonKey(name: 'actors', fromJson: stringListfromList)
  final List<String>? actors;
  @JsonKey(name: 'added_at', fromJson: dateTimeFromEpochSeconds)
  final DateTime? addedAt;
  @JsonKey(name: 'audience_rating', fromJson: Cast.castToDouble)
  final double? audienceRating;
  @JsonKey(name: 'collections', fromJson: stringListfromList)
  final List<String>? collections;
  @JsonKey(name: 'content_rating', fromJson: Cast.castToString)
  final String? contentRating;
  @JsonKey(name: 'directors', fromJson: stringListfromList)
  final List<String>? directors;
  @JsonKey(name: 'duration', fromJson: durationFromMilliseconds)
  final Duration? duration;
  @JsonKey(name: 'full_title', fromJson: Cast.castToString)
  final String? fullTitle;
  @JsonKey(name: 'genres', fromJson: stringListfromList)
  final List<String>? genres;
  @JsonKey(name: 'grandparent_rating_key', fromJson: Cast.castToInt)
  final int? grandparentRatingKey;
  @JsonKey(name: 'grandparent_thumb', fromJson: Cast.castToString)
  final String? grandparentThumb;
  @JsonKey(name: 'grandparent_title', fromJson: Cast.castToString)
  final String? grandparentTitle;
  final Uri? grandparentImageUri;
  final Uri? imageUri;
  @JsonKey(name: 'labels', fromJson: stringListfromList)
  final List<String>? labels;
  @JsonKey(name: 'last_viewed_at', fromJson: dateTimeFromEpochSeconds)
  final DateTime? lastViewedAt;
  @JsonKey(name: 'library_name', fromJson: Cast.castToString)
  final String? libraryName;
  @JsonKey(name: 'live', fromJson: Cast.castToBool)
  final bool? live;
  @JsonKey(name: 'media_index', fromJson: Cast.castToInt)
  final int? mediaIndex;
  @JsonKey(name: 'media_info', fromJson: mediaInfoModelFromJson)
  final MediaInfoModel? mediaInfo;
  @JsonKey(name: 'media_type', fromJson: Cast.castStringToMediaType)
  final MediaType? mediaType;
  @JsonKey(name: 'original_tital', fromJson: Cast.castToString)
  final String? originalTitle;
  @JsonKey(name: 'originally_available_at', fromJson: dateTimeFromString)
  final DateTime? originallyAvailableAt;
  final Uri? parentImageUri;
  @JsonKey(name: 'parent_media_index', fromJson: Cast.castToInt)
  final int? parentMediaIndex;
  @JsonKey(name: 'parent_rating_key', fromJson: Cast.castToInt)
  final int? parentRatingKey;
  @JsonKey(name: 'parent_thumb', fromJson: Cast.castToString)
  final String? parentThumb;
  @JsonKey(name: 'parent_title', fromJson: Cast.castToString)
  final String? parentTitle;
  @JsonKey(name: 'parent_year', fromJson: Cast.castToInt)
  final int? parentYear;
  @JsonKey(name: 'rating', fromJson: Cast.castToDouble)
  final double? rating;
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
  @JsonKey(name: 'updated_at', fromJson: dateTimeFromEpochSeconds)
  final DateTime? updatedAt;
  @JsonKey(name: 'user_rating', fromJson: Cast.castToDouble)
  final double? userRating;
  @JsonKey(name: 'writers', fromJson: stringListfromList)
  final List<String>? writers;
  @JsonKey(name: 'year', fromJson: Cast.castToInt)
  final int? year;

  const MediaModel({
    this.actors,
    this.addedAt,
    this.audienceRating,
    this.collections,
    this.contentRating,
    this.directors,
    this.duration,
    this.fullTitle,
    this.genres,
    this.grandparentRatingKey,
    this.grandparentThumb,
    this.grandparentTitle,
    this.grandparentImageUri,
    this.imageUri,
    this.labels,
    this.lastViewedAt,
    this.libraryName,
    this.live,
    this.mediaIndex,
    this.mediaInfo,
    this.mediaType,
    this.originalTitle,
    this.originallyAvailableAt,
    this.parentImageUri,
    this.parentMediaIndex,
    this.parentRatingKey,
    this.parentThumb,
    this.parentTitle,
    this.parentYear,
    this.rating,
    this.ratingKey,
    this.sectionId,
    this.sortTitle,
    this.studio,
    this.summary,
    this.tagline,
    this.thumb,
    this.title,
    this.updatedAt,
    this.userRating,
    this.writers,
    this.year,
  });

  MediaModel copyWith({
    final List<String>? actors,
    final DateTime? addedAt,
    final double? audienceRating,
    final List<String>? collections,
    final String? contentRating,
    final List<String>? directors,
    final Duration? duration,
    final String? fullTitle,
    final List<String>? genres,
    final int? grandparentRatingKey,
    final String? grandparentThumb,
    final String? grandparentTitle,
    final Uri? grandparentImageUri,
    final Uri? imageUri,
    final List<String>? labels,
    final DateTime? lastViewedAt,
    final String? libraryName,
    final bool? live,
    final int? mediaIndex,
    final MediaInfoModel? mediaInfo,
    final MediaType? mediaType,
    final String? originalTitle,
    final DateTime? originallyAvailableAt,
    final Uri? parentImageUri,
    final int? parentMediaIndex,
    final int? parentRatingKey,
    final String? parentThumb,
    final String? parentTitle,
    final int? parentYear,
    final double? rating,
    final int? ratingKey,
    final int? sectionId,
    final String? sortTitle,
    final String? studio,
    final String? summary,
    final String? tagline,
    final String? thumb,
    final String? title,
    final DateTime? updatedAt,
    final double? userRating,
    final List<String>? writers,
    final int? year,
  }) {
    return MediaModel(
      actors: actors ?? this.actors,
      addedAt: addedAt ?? this.addedAt,
      audienceRating: audienceRating ?? this.audienceRating,
      collections: collections ?? this.collections,
      contentRating: contentRating ?? this.contentRating,
      directors: directors ?? this.directors,
      duration: duration ?? this.duration,
      fullTitle: fullTitle ?? this.fullTitle,
      genres: genres ?? this.genres,
      grandparentRatingKey: grandparentRatingKey ?? this.grandparentRatingKey,
      grandparentThumb: grandparentThumb ?? this.grandparentThumb,
      grandparentTitle: grandparentTitle ?? this.grandparentTitle,
      grandparentImageUri: grandparentImageUri ?? this.grandparentImageUri,
      imageUri: imageUri ?? this.imageUri,
      labels: labels ?? this.labels,
      lastViewedAt: lastViewedAt ?? this.lastViewedAt,
      libraryName: libraryName ?? this.libraryName,
      live: live ?? this.live,
      mediaIndex: mediaIndex ?? this.mediaIndex,
      mediaInfo: mediaInfo ?? this.mediaInfo,
      mediaType: mediaType ?? this.mediaType,
      originalTitle: originalTitle ?? this.originalTitle,
      originallyAvailableAt: originallyAvailableAt ?? this.originallyAvailableAt,
      parentImageUri: parentImageUri ?? this.parentImageUri,
      parentMediaIndex: parentMediaIndex ?? this.parentMediaIndex,
      parentRatingKey: parentRatingKey ?? this.parentRatingKey,
      parentThumb: parentThumb ?? this.parentThumb,
      parentTitle: parentTitle ?? this.parentTitle,
      parentYear: parentYear ?? this.parentYear,
      rating: rating ?? this.rating,
      ratingKey: ratingKey ?? this.ratingKey,
      sectionId: sectionId ?? this.sectionId,
      sortTitle: sortTitle ?? this.sortTitle,
      studio: studio ?? this.studio,
      summary: summary ?? this.summary,
      tagline: tagline ?? this.tagline,
      thumb: thumb ?? this.thumb,
      title: title ?? this.title,
      updatedAt: updatedAt ?? this.updatedAt,
      userRating: userRating ?? this.userRating,
      writers: writers ?? this.writers,
      year: year ?? this.year,
    );
  }

  factory MediaModel.fromJson(Map<String, dynamic> json) => _$MediaModelFromJson(json);

  Map<String, dynamic> toJson() => _$MediaModelToJson(this);

  static DateTime? dateTimeFromEpochSeconds(String? secondsSinceEpoch) {
    if (secondsSinceEpoch == null) return null;

    final intSecondsSinceEpoch = int.tryParse(secondsSinceEpoch);
    if (intSecondsSinceEpoch == null) return null;

    return DateTime.fromMillisecondsSinceEpoch(intSecondsSinceEpoch * 1000);
  }

  static DateTime? dateTimeFromString(String? date) {
    if (date == null) return null;
    return DateTime.tryParse(date);
  }

  static Duration? durationFromMilliseconds(String? millisecondsString) {
    final milliseconds = Cast.castToInt(millisecondsString);

    if (milliseconds == null) return null;

    return Duration(milliseconds: milliseconds);
  }

  static MediaInfoModel? mediaInfoModelFromJson(List? mediaInfoList) {
    if (mediaInfoList == null || mediaInfoList.isEmpty) return null;

    return MediaInfoModel.fromJson(mediaInfoList[0]);
  }

  static List<String>? stringListfromList(List? list) {
    if (list == null || list.isEmpty) return null;

    return list.map((item) => item.toString()).toList();
  }

  @override
  List<Object?> get props => [
        actors,
        addedAt,
        audienceRating,
        collections,
        contentRating,
        directors,
        duration,
        fullTitle,
        genres,
        grandparentRatingKey,
        grandparentThumb,
        grandparentTitle,
        grandparentImageUri,
        imageUri,
        labels,
        lastViewedAt,
        libraryName,
        live,
        mediaIndex,
        mediaInfo,
        mediaType,
        originalTitle,
        originallyAvailableAt,
        parentImageUri,
        parentMediaIndex,
        parentRatingKey,
        parentThumb,
        parentTitle,
        parentYear,
        rating,
        ratingKey,
        sectionId,
        sortTitle,
        studio,
        summary,
        tagline,
        thumb,
        title,
        updatedAt,
        userRating,
        writers,
        year,
      ];
}
