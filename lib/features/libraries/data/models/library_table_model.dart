import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/types/media_type.dart';
import '../../../../core/types/section_type.dart';
import '../../../../core/utilities/cast.dart';

part 'library_table_model.g.dart';

@JsonSerializable()
class LibraryTableModel extends Equatable {
  final Uri? backgroundUri;
  @JsonKey(name: 'child_count', fromJson: Cast.castToInt)
  final int? childCount;
  @JsonKey(name: 'content_rating', fromJson: Cast.castToString)
  final String? contentRating;
  @JsonKey(name: 'count', fromJson: Cast.castToInt)
  final int? count;
  @JsonKey(name: 'do_notify', fromJson: Cast.castToBool)
  final bool? doNotify;
  @JsonKey(name: 'do_notify_created', fromJson: Cast.castToBool)
  final bool? doNotifyCreated;
  @JsonKey(name: 'duration', fromJson: durationFromSeconds)
  final Duration? duration;
  @JsonKey(name: 'guid', fromJson: Cast.castToString)
  final String? guid;
  @JsonKey(name: 'history_row', fromJson: Cast.castToInt)
  final int? historyRow;
  final Uri? iconUri;
  @JsonKey(name: 'is_active', fromJson: Cast.castToBool)
  final bool? isActive;
  @JsonKey(name: 'keep_history', fromJson: Cast.castToBool)
  final bool? keepHistory;
  @JsonKey(name: 'labels')
  final List<String>? labels;
  @JsonKey(name: 'last_accessed', fromJson: dateTimeFromEpochSeconds)
  final DateTime? lastAccessed;
  @JsonKey(name: 'last_played', fromJson: Cast.castToString)
  final String? lastPlayed;
  @JsonKey(name: 'library_art', fromJson: Cast.castToString)
  final String? libraryArt;
  @JsonKey(name: 'library_thumb', fromJson: Cast.castToString)
  final String? libraryThumb;
  @JsonKey(name: 'live', fromJson: Cast.castToBool)
  final bool? live;
  @JsonKey(name: 'media_index', fromJson: Cast.castToInt)
  final int? mediaIndex;
  @JsonKey(name: 'media_type', fromJson: Cast.castStringToMediaType)
  final MediaType? mediaType;
  @JsonKey(name: 'originally_available_at', fromJson: dateTimeFromString)
  final DateTime? originallyAvailableAt;
  @JsonKey(name: 'parent_count', fromJson: Cast.castToInt)
  final int? parentCount;
  @JsonKey(name: 'parent_media_index', fromJson: Cast.castToInt)
  final int? parentMediaIndex;
  @JsonKey(name: 'parent_title', fromJson: Cast.castToString)
  final String? parentTitle;
  @JsonKey(name: 'plays', fromJson: Cast.castToInt)
  final int? plays;
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
  @JsonKey(name: 'server_id', fromJson: Cast.castToString)
  final String? serverId;
  @JsonKey(name: 'thumb', fromJson: Cast.castToString)
  final String? thumb;
  @JsonKey(name: 'year', fromJson: Cast.castToInt)
  final int? year;

  const LibraryTableModel({
    this.backgroundUri,
    this.childCount,
    this.contentRating,
    this.count,
    this.doNotify,
    this.doNotifyCreated,
    this.duration,
    this.guid,
    this.historyRow,
    this.iconUri,
    this.isActive,
    this.keepHistory,
    this.labels,
    this.lastAccessed,
    this.lastPlayed,
    this.libraryArt,
    this.libraryThumb,
    this.live,
    this.mediaIndex,
    this.mediaType,
    this.originallyAvailableAt,
    this.parentCount,
    this.parentMediaIndex,
    this.parentTitle,
    this.plays,
    this.ratingKey,
    this.rowId,
    this.sectionId,
    this.sectionName,
    this.sectionType,
    this.serverId,
    this.thumb,
    this.year,
  });

  LibraryTableModel copyWith({
    Uri? backgroundUri,
    int? childCount,
    String? contentRating,
    int? count,
    bool? doNotify,
    bool? doNotifyCreated,
    Duration? duration,
    String? guid,
    int? historyRow,
    Uri? iconUri,
    bool? isActive,
    bool? keepHistory,
    List<String>? labels,
    DateTime? lastAccessed,
    String? lastPlayed,
    String? libraryArt,
    String? libraryThumb,
    bool? live,
    int? mediaIndex,
    MediaType? mediaType,
    DateTime? originallyAvailableAt,
    int? parentCount,
    int? parentMediaIndex,
    String? parentTitle,
    int? plays,
    int? ratingKey,
    int? rowId,
    int? sectionId,
    String? sectionName,
    SectionType? sectionType,
    String? serverId,
    String? thumb,
    int? year,
  }) {
    return LibraryTableModel(
      backgroundUri: backgroundUri ?? this.backgroundUri,
      childCount: childCount ?? this.childCount,
      contentRating: contentRating ?? this.contentRating,
      count: count ?? this.count,
      doNotify: doNotify ?? this.doNotify,
      doNotifyCreated: doNotifyCreated ?? this.doNotifyCreated,
      duration: duration ?? this.duration,
      guid: guid ?? this.guid,
      historyRow: historyRow ?? this.historyRow,
      iconUri: iconUri ?? this.iconUri,
      isActive: isActive ?? this.isActive,
      keepHistory: keepHistory ?? this.keepHistory,
      labels: labels ?? this.labels,
      lastAccessed: lastAccessed ?? this.lastAccessed,
      lastPlayed: lastPlayed ?? this.lastPlayed,
      libraryArt: libraryArt ?? this.libraryArt,
      libraryThumb: libraryThumb ?? this.libraryThumb,
      live: live ?? this.live,
      mediaIndex: mediaIndex ?? this.mediaIndex,
      mediaType: mediaType ?? this.mediaType,
      originallyAvailableAt:
          originallyAvailableAt ?? this.originallyAvailableAt,
      parentCount: parentCount ?? this.parentCount,
      parentMediaIndex: parentMediaIndex ?? this.parentMediaIndex,
      parentTitle: parentTitle ?? this.parentTitle,
      plays: plays ?? this.plays,
      ratingKey: ratingKey ?? this.ratingKey,
      rowId: rowId ?? this.rowId,
      sectionId: sectionId ?? this.sectionId,
      sectionName: sectionName ?? this.sectionName,
      sectionType: sectionType ?? this.sectionType,
      serverId: serverId ?? this.serverId,
      thumb: thumb ?? this.thumb,
      year: year ?? this.year,
    );
  }

  factory LibraryTableModel.fromJson(Map<String, dynamic> json) =>
      _$LibraryTableModelFromJson(json);

  Map<String, dynamic> toJson() => _$LibraryTableModelToJson(this);

  static DateTime? dateTimeFromString(String? date) {
    if (date == null) return null;
    return DateTime.tryParse(date);
  }

  static DateTime? dateTimeFromEpochSeconds(int? secondsSinceEpoch) {
    if (secondsSinceEpoch == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(secondsSinceEpoch * 1000);
  }

  static Duration? durationFromSeconds(int? seconds) {
    if (seconds == null) return null;
    return Duration(seconds: seconds);
  }

  @override
  List<Object?> get props => [];
}
