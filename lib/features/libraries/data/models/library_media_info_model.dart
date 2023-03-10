import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/types/media_type.dart';
import '../../../../core/types/section_type.dart';
import '../../../../core/utilities/cast.dart';

part 'library_media_info_model.g.dart';

@JsonSerializable()
class LibraryMediaInfoModel extends Equatable {
  @JsonKey(name: 'added_at', fromJson: dateTimeFromStringEpochSeconds)
  final DateTime? addedAt;
  @JsonKey(name: 'grandparent_rating_key', fromJson: Cast.castToInt)
  final int? grandparentRatingKey;
  @JsonKey(name: 'last_played', fromJson: dateTimeFromEpochSeconds)
  final DateTime? lastPlayed;
  @JsonKey(name: 'media_index', fromJson: Cast.castToInt)
  final int? mediaIndex;
  @JsonKey(name: 'media_type', fromJson: Cast.castStringToMediaType)
  final MediaType? mediaType;
  @JsonKey(name: 'parent_media_index', fromJson: Cast.castToInt)
  final int? parentMediaIndex;
  @JsonKey(name: 'parent_rating_key', fromJson: Cast.castToInt)
  final int? parentRatingKey;
  @JsonKey(name: 'play_count', fromJson: Cast.castToInt)
  final int? playCount;
  final Uri? posterUri;
  @JsonKey(name: 'section_id', fromJson: Cast.castToInt)
  final int? sectionId;
  @JsonKey(name: 'section_type', fromJson: Cast.castStringToSectionType)
  final SectionType? sectionType;
  @JsonKey(name: 'rating_key', fromJson: Cast.castToInt)
  final int? ratingKey;
  @JsonKey(name: 'sort_title', fromJson: Cast.castToString)
  final String? sortTitle;
  @JsonKey(name: 'thumb', fromJson: Cast.castToString)
  final String? thumb;
  @JsonKey(name: 'title', fromJson: Cast.castToString)
  final String? title;
  @JsonKey(name: 'year', fromJson: Cast.castToInt)
  final int? year;

  const LibraryMediaInfoModel({
    this.addedAt,
    this.grandparentRatingKey,
    this.lastPlayed,
    this.mediaIndex,
    this.mediaType,
    this.parentMediaIndex,
    this.parentRatingKey,
    this.playCount,
    this.posterUri,
    this.sectionId,
    this.sectionType,
    this.ratingKey,
    this.sortTitle,
    this.thumb,
    this.title,
    this.year,
  });

  LibraryMediaInfoModel copyWith({
    final DateTime? addedAt,
    final int? grandparentRatingKey,
    final DateTime? lastPlayed,
    final int? mediaIndex,
    final MediaType? mediaType,
    final int? parentMediaIndex,
    final int? parentRatingKey,
    final int? playCount,
    final Uri? posterUri,
    final int? sectionId,
    final SectionType? sectionType,
    final int? ratingKey,
    final String? sortTitle,
    final String? thumb,
    final String? title,
    final int? year,
  }) {
    return LibraryMediaInfoModel(
      addedAt: addedAt ?? this.addedAt,
      grandparentRatingKey: grandparentRatingKey ?? this.grandparentRatingKey,
      lastPlayed: lastPlayed ?? this.lastPlayed,
      mediaIndex: mediaIndex ?? this.mediaIndex,
      mediaType: mediaType ?? this.mediaType,
      parentMediaIndex: parentMediaIndex ?? this.parentMediaIndex,
      parentRatingKey: parentRatingKey ?? this.parentRatingKey,
      playCount: playCount ?? this.playCount,
      posterUri: posterUri ?? this.posterUri,
      sectionId: sectionId ?? this.sectionId,
      sectionType: sectionType ?? this.sectionType,
      ratingKey: ratingKey ?? this.ratingKey,
      sortTitle: sortTitle ?? this.sortTitle,
      thumb: thumb ?? this.thumb,
      title: title ?? this.title,
      year: year ?? this.year,
    );
  }

  factory LibraryMediaInfoModel.fromJson(Map<String, dynamic> json) => _$LibraryMediaInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$LibraryMediaInfoModelToJson(this);

  static DateTime? dateTimeFromStringEpochSeconds(String? secondsSinceEpochString) {
    final secondsSinceEpoch = Cast.castToInt(secondsSinceEpochString);

    if (secondsSinceEpoch == null) return null;

    return DateTime.fromMillisecondsSinceEpoch(secondsSinceEpoch * 1000);
  }

  static DateTime? dateTimeFromEpochSeconds(int? secondsSinceEpoch) {
    if (secondsSinceEpoch == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(secondsSinceEpoch * 1000);
  }

  @override
  List<Object?> get props => [];
}
