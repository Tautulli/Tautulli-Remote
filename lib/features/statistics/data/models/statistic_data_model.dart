import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/types/section_type.dart';
import '../../../../core/types/tautulli_types.dart';
import '../../../../core/utilities/cast.dart';

part 'statistic_data_model.g.dart';

@JsonSerializable()
class StatisticDataModel extends Equatable {
  @JsonKey(name: 'art', fromJson: Cast.castToString)
  final String? art;
  @JsonKey(name: 'count', fromJson: Cast.castToInt)
  final int? count;
  @JsonKey(name: 'friendly_name', fromJson: Cast.castToString)
  final String? friendlyName;
  @JsonKey(name: 'grandchild_title', fromJson: Cast.castToString)
  final String? grandchildTitle;
  @JsonKey(name: 'grandparent_rating_key', fromJson: Cast.castToInt)
  final int? grandparentRatingKey;
  @JsonKey(name: 'grandparent_thumb', fromJson: Cast.castToString)
  final String? grandparentThumb;
  @JsonKey(name: 'grandparent_title', fromJson: Cast.castToString)
  final String? grandparentTitle;
  final Uri? iconUri;
  @JsonKey(name: 'last_play', fromJson: dateTimeFromEpochSeconds)
  final DateTime? lastPlay;
  @JsonKey(name: 'last_watch', fromJson: dateTimeFromEpochSeconds)
  final DateTime? lastWatch;
  @JsonKey(name: 'media_index', fromJson: Cast.castToInt)
  final int? mediaIndex;
  @JsonKey(name: 'media_type', fromJson: Cast.castStringToMediaType)
  final MediaType? mediaType;
  @JsonKey(name: 'parent_media_index', fromJson: Cast.castToInt)
  final int? parentMediaIndex;
  @JsonKey(name: 'platform', fromJson: Cast.castToString)
  final String? platform;
  @JsonKey(name: 'platform_name', fromJson: Cast.castToString)
  final String? platformName;
  final Uri? posterUri;
  @JsonKey(name: 'rating_key', fromJson: Cast.castToInt)
  final int? ratingKey;
  @JsonKey(name: 'row_id', fromJson: Cast.castToInt)
  final int? rowId;
  @JsonKey(name: 'section_id', fromJson: Cast.castToInt)
  final int? sectionId;
  @JsonKey(name: 'section_name', fromJson: Cast.castToString)
  final String? sectionName;
  @JsonKey(name: 'section_type', fromJson: Cast.castStringToSectionType)
  final SectionType? sectionType;
  @JsonKey(name: 'started', fromJson: dateTimeFromEpochSeconds)
  final DateTime? started;
  @JsonKey(name: 'thumb', fromJson: Cast.castToString)
  final String? thumb;
  @JsonKey(name: 'title', fromJson: Cast.castToString)
  final String? title;
  @JsonKey(name: 'total_duration', fromJson: durationFromJson)
  final Duration? totalDuration;
  @JsonKey(name: 'total_plays', fromJson: Cast.castToInt)
  final int? totalPlays;
  @JsonKey(name: 'user', fromJson: Cast.castToString)
  final String? user;
  @JsonKey(name: 'user_id', fromJson: Cast.castToInt)
  final int? userId;
  @JsonKey(name: 'users_watched', fromJson: Cast.castToInt)
  final int? usersWatched;
  @JsonKey(name: 'user_thumb', fromJson: Cast.castToString)
  final String? userThumb;
  @JsonKey(name: 'year', fromJson: Cast.castToInt)
  final int? year;

  const StatisticDataModel({
    this.art,
    this.count,
    this.friendlyName,
    this.grandchildTitle,
    this.grandparentRatingKey,
    this.grandparentThumb,
    this.grandparentTitle,
    this.iconUri,
    this.lastPlay,
    this.lastWatch,
    this.mediaIndex,
    this.mediaType,
    this.parentMediaIndex,
    this.platform,
    this.platformName,
    this.posterUri,
    this.ratingKey,
    this.rowId,
    this.sectionId,
    this.sectionName,
    this.sectionType,
    this.started,
    this.thumb,
    this.title,
    this.totalDuration,
    this.totalPlays,
    this.user,
    this.userId,
    this.usersWatched,
    this.userThumb,
    this.year,
  });

  StatisticDataModel copyWith({
    final String? art,
    final int? count,
    final String? friendlyName,
    final String? grandchildTitle,
    final int? grandparentRatingKey,
    final String? grandparentThumb,
    final String? grandparentTitle,
    final Uri? iconUri,
    final DateTime? lastPlay,
    final DateTime? lastWatch,
    final int? mediaIndex,
    final MediaType? mediaType,
    final int? parentMediaIndex,
    final String? platform,
    final String? platformName,
    final Uri? posterUri,
    final int? ratingKey,
    final int? rowId,
    final int? sectionId,
    final String? sectionName,
    final SectionType? sectionType,
    final DateTime? started,
    final String? thumb,
    final String? title,
    final Duration? totalDuration,
    final int? totalPlays,
    final String? user,
    final int? userId,
    final int? usersWatched,
    final String? userThumb,
    final int? year,
  }) {
    return StatisticDataModel(
      art: art ?? this.art,
      count: count ?? this.count,
      friendlyName: friendlyName ?? this.friendlyName,
      grandchildTitle: grandchildTitle ?? this.grandchildTitle,
      grandparentRatingKey: grandparentRatingKey ?? this.grandparentRatingKey,
      grandparentThumb: grandparentThumb ?? this.grandparentThumb,
      grandparentTitle: grandparentTitle ?? this.grandparentTitle,
      iconUri: iconUri ?? this.iconUri,
      lastPlay: lastPlay ?? this.lastPlay,
      lastWatch: lastWatch ?? this.lastWatch,
      mediaIndex: mediaIndex ?? this.mediaIndex,
      mediaType: mediaType ?? this.mediaType,
      parentMediaIndex: parentMediaIndex ?? this.parentMediaIndex,
      platform: platform ?? this.platform,
      platformName: platformName ?? this.platformName,
      posterUri: posterUri ?? this.posterUri,
      ratingKey: ratingKey ?? this.ratingKey,
      rowId: rowId ?? this.rowId,
      sectionId: sectionId ?? this.sectionId,
      sectionName: sectionName ?? this.sectionName,
      sectionType: sectionType ?? this.sectionType,
      started: started ?? this.started,
      thumb: thumb ?? this.thumb,
      title: title ?? this.title,
      totalDuration: totalDuration ?? this.totalDuration,
      totalPlays: totalPlays ?? this.totalPlays,
      user: user ?? this.user,
      userId: userId ?? this.userId,
      usersWatched: usersWatched ?? this.usersWatched,
      userThumb: userThumb ?? this.userThumb,
      year: year ?? this.year,
    );
  }

  factory StatisticDataModel.fromJson(Map<String, dynamic> json) => _$StatisticDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$StatisticDataModelToJson(this);

  static DateTime? dateTimeFromEpochSeconds(dynamic secondsSinceEpoch) {
    final secondsSinceEpochInt = Cast.castToInt(secondsSinceEpoch);

    if (secondsSinceEpochInt == null) return null;

    return DateTime.fromMillisecondsSinceEpoch(secondsSinceEpochInt * 1000);
  }

  static Duration? durationFromJson(int? seconds) {
    if (seconds == null) return null;
    return Duration(seconds: seconds);
  }

  @override
  List<Object?> get props => [
        art,
        count,
        friendlyName,
        grandchildTitle,
        grandparentRatingKey,
        grandparentThumb,
        grandparentTitle,
        iconUri,
        lastPlay,
        lastWatch,
        mediaIndex,
        mediaType,
        parentMediaIndex,
        platform,
        platformName,
        posterUri,
        ratingKey,
        rowId,
        sectionId,
        sectionName,
        sectionType,
        started,
        thumb,
        title,
        totalDuration,
        totalPlays,
        user,
        userId,
        usersWatched,
        userThumb,
        year,
      ];
}
