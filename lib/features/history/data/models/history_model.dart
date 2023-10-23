import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/types/tautulli_types.dart';
import '../../../../core/utilities/cast.dart';

part 'history_model.g.dart';

@JsonSerializable()
class HistoryModel extends Equatable {
  @JsonKey(name: 'date', fromJson: dateTimeFromEpochSeconds)
  final DateTime? date;
  @JsonKey(name: 'duration', fromJson: durationFromJson)
  final Duration? duration;
  @JsonKey(name: 'friendly_name', fromJson: Cast.castToString)
  final String? friendlyName;
  @JsonKey(name: 'full_title', fromJson: Cast.castToString)
  final String? fullTitle;
  @JsonKey(name: 'grandparent_rating_key', fromJson: Cast.castToInt)
  final int? grandparentRatingKey;
  @JsonKey(name: 'grandparent_title', fromJson: Cast.castToString)
  final String? grandparentTitle;
  @JsonKey(name: 'group_count', fromJson: Cast.castToInt)
  final int? groupCount;
  @JsonKey(name: 'group_ids', fromJson: groupIdsFromJson)
  final List<int>? groupIds;
  @JsonKey(name: 'guid', fromJson: Cast.castToString)
  final String? guid;
  @JsonKey(name: 'id', fromJson: Cast.castToInt)
  final int? id;
  @JsonKey(name: 'ip_address', fromJson: Cast.castToString)
  final String? ipAddress;
  @JsonKey(name: 'live', fromJson: Cast.castToBool)
  final bool? live;
  @JsonKey(name: 'location', fromJson: Cast.castStringToLocation)
  final Location? location;
  @JsonKey(name: 'machine_id', fromJson: Cast.castToString)
  final String? machineId;
  @JsonKey(name: 'media_index', fromJson: Cast.castToInt)
  final int? mediaIndex;
  @JsonKey(name: 'media_type', fromJson: Cast.castStringToMediaType)
  final MediaType? mediaType;
  @JsonKey(name: 'originally_available_at', fromJson: dateTimeFromString)
  final DateTime? originallyAvailableAt;
  @JsonKey(name: 'original_title', fromJson: Cast.castToString)
  final String? originalTitle;
  @JsonKey(name: 'parent_media_index', fromJson: Cast.castToInt)
  final int? parentMediaIndex;
  @JsonKey(name: 'parent_rating_key', fromJson: Cast.castToInt)
  final int? parentRatingKey;
  @JsonKey(name: 'parent_title', fromJson: Cast.castToString)
  final String? parentTitle;
  @JsonKey(name: 'paused_counter', fromJson: durationFromJson)
  final Duration? pausedCounter;
  @JsonKey(name: 'percent_complete', fromJson: Cast.castToInt)
  final int? percentComplete;
  @JsonKey(name: 'platform', fromJson: Cast.castToString)
  final String? platform;
  @JsonKey(name: 'player', fromJson: Cast.castToString)
  final String? player;
  final Uri? posterUri;
  @JsonKey(name: 'product', fromJson: Cast.castToString)
  final String? product;
  @JsonKey(name: 'rating_key', fromJson: Cast.castToInt)
  final int? ratingKey;
  @JsonKey(name: 'reference_id', fromJson: Cast.castToInt)
  final int? referenceId;
  @JsonKey(name: 'relayed', fromJson: Cast.castToBool)
  final bool? relayed;
  @JsonKey(name: 'row_id', fromJson: Cast.castToInt)
  final int? rowId;
  @JsonKey(name: 'secure', fromJson: Cast.castToBool)
  final bool? secure;
  @JsonKey(name: 'session_key', fromJson: Cast.castToInt)
  final int? sessionKey;
  @JsonKey(name: 'started', fromJson: dateTimeFromEpochSeconds)
  final DateTime? started;
  @JsonKey(name: 'state', fromJson: Cast.castStringToPlaybackState)
  final PlaybackState? state;
  @JsonKey(name: 'stopped', fromJson: dateTimeFromEpochSeconds)
  final DateTime? stopped;
  @JsonKey(name: 'thumb', fromJson: Cast.castToString)
  final String? thumb;
  @JsonKey(name: 'title', fromJson: Cast.castToString)
  final String? title;
  @JsonKey(name: 'transcode_decision', fromJson: Cast.castStringToStreamDecision)
  final StreamDecision? transcodeDecision;
  @JsonKey(name: 'user', fromJson: Cast.castToString)
  final String? user;
  @JsonKey(name: 'user_id', fromJson: Cast.castToInt)
  final int? userId;
  @JsonKey(name: 'user_thumb', fromJson: Cast.castToString)
  final String? userThumb;
  @JsonKey(name: 'watched_status', fromJson: watchedStatusFromDouble)
  final WatchedStatus? watchedStatus;
  @JsonKey(name: 'year', fromJson: Cast.castToInt)
  final int? year;

  const HistoryModel({
    this.date,
    this.duration,
    this.friendlyName,
    this.fullTitle,
    this.grandparentRatingKey,
    this.grandparentTitle,
    this.groupCount,
    this.groupIds,
    this.guid,
    this.id,
    this.ipAddress,
    this.live,
    this.location,
    this.machineId,
    this.mediaIndex,
    this.mediaType,
    this.originallyAvailableAt,
    this.originalTitle,
    this.parentMediaIndex,
    this.parentRatingKey,
    this.parentTitle,
    this.pausedCounter,
    this.percentComplete,
    this.platform,
    this.player,
    this.posterUri,
    this.product,
    this.ratingKey,
    this.referenceId,
    this.relayed,
    this.rowId,
    this.secure,
    this.sessionKey,
    this.started,
    this.state,
    this.stopped,
    this.thumb,
    this.title,
    this.transcodeDecision,
    this.user,
    this.userId,
    this.userThumb,
    this.watchedStatus,
    this.year,
  });

  HistoryModel copyWith({
    final DateTime? date,
    final Duration? duration,
    final String? friendlyName,
    final String? fullTitle,
    final int? grandparentRatingKey,
    final String? grandparentTitle,
    final int? groupCount,
    final List<int>? groupIds,
    final String? guid,
    final int? id,
    final String? ipAddress,
    final bool? live,
    final Location? location,
    final String? machineId,
    final int? mediaIndex,
    final MediaType? mediaType,
    final DateTime? originallyAvailableAt,
    final String? originalTitle,
    final int? parentMediaIndex,
    final int? parentRatingKey,
    final String? parentTitle,
    final Duration? pausedCounter,
    final int? percentComplete,
    final String? platform,
    final String? player,
    final Uri? posterUri,
    final String? product,
    final int? ratingKey,
    final int? referenceId,
    final bool? relayed,
    final int? rowId,
    final bool? secure,
    final int? sessionKey,
    final DateTime? started,
    final PlaybackState? state,
    final DateTime? stopped,
    final String? thumb,
    final String? title,
    final StreamDecision? transcodeDecision,
    final String? user,
    final int? userId,
    final String? userThumb,
    final WatchedStatus? watchedStatus,
    final int? year,
  }) {
    return HistoryModel(
      date: date ?? this.date,
      duration: duration ?? this.duration,
      friendlyName: friendlyName ?? this.friendlyName,
      fullTitle: fullTitle ?? this.fullTitle,
      grandparentRatingKey: grandparentRatingKey ?? this.grandparentRatingKey,
      grandparentTitle: grandparentTitle ?? this.grandparentTitle,
      groupCount: groupCount ?? this.groupCount,
      groupIds: groupIds ?? this.groupIds,
      guid: guid ?? this.guid,
      id: id ?? this.id,
      ipAddress: ipAddress ?? this.ipAddress,
      live: live ?? this.live,
      location: location ?? this.location,
      machineId: machineId ?? this.machineId,
      mediaIndex: mediaIndex ?? this.mediaIndex,
      mediaType: mediaType ?? this.mediaType,
      originallyAvailableAt: originallyAvailableAt ?? this.originallyAvailableAt,
      originalTitle: originalTitle ?? this.originalTitle,
      parentMediaIndex: parentMediaIndex ?? this.parentMediaIndex,
      parentRatingKey: parentRatingKey ?? this.parentRatingKey,
      parentTitle: parentTitle ?? this.parentTitle,
      pausedCounter: pausedCounter ?? this.pausedCounter,
      percentComplete: percentComplete ?? this.percentComplete,
      platform: platform ?? this.platform,
      posterUri: posterUri ?? this.posterUri,
      player: player ?? this.player,
      product: product ?? this.product,
      ratingKey: ratingKey ?? this.ratingKey,
      referenceId: referenceId ?? this.referenceId,
      relayed: relayed ?? this.relayed,
      rowId: rowId ?? this.rowId,
      secure: secure ?? this.secure,
      sessionKey: sessionKey ?? this.sessionKey,
      started: started ?? this.started,
      state: state ?? this.state,
      stopped: stopped ?? this.stopped,
      thumb: thumb ?? this.thumb,
      title: title ?? this.title,
      transcodeDecision: transcodeDecision ?? this.transcodeDecision,
      user: user ?? this.user,
      userId: userId ?? this.userId,
      userThumb: userThumb ?? this.userThumb,
      watchedStatus: watchedStatus ?? this.watchedStatus,
      year: year ?? this.year,
    );
  }

  factory HistoryModel.fromJson(Map<String, dynamic> json) => _$HistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryModelToJson(this);

  static DateTime? dateTimeFromString(String? date) {
    if (date == null) return null;
    return DateTime.tryParse(date);
  }

  static DateTime? dateTimeFromEpochSeconds(int? secondsSinceEpoch) {
    if (secondsSinceEpoch == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(secondsSinceEpoch * 1000);
  }

  static Duration? durationFromJson(int? seconds) {
    if (seconds == null) return null;
    return Duration(seconds: seconds);
  }

  static List<int>? groupIdsFromJson(String? groupIds) {
    if (groupIds == null) return null;
    return groupIds.split(',').map(int.parse).toList();
  }

  static WatchedStatus watchedStatusFromDouble(num value) {
    if (value < 0.25) {
      return WatchedStatus.empty;
    } else if (value < 0.5) {
      return WatchedStatus.quarter;
    } else if (value < 0.75) {
      return WatchedStatus.half;
    } else if (value < 1) {
      return WatchedStatus.threeQuarter;
    } else {
      return WatchedStatus.full;
    }
  }

  @override
  List<Object?> get props => [
        date,
        duration,
        friendlyName,
        fullTitle,
        grandparentRatingKey,
        grandparentTitle,
        groupCount,
        groupIds,
        guid,
        id,
        ipAddress,
        live,
        location,
        machineId,
        mediaIndex,
        mediaType,
        originallyAvailableAt,
        originalTitle,
        parentMediaIndex,
        parentRatingKey,
        parentTitle,
        pausedCounter,
        percentComplete,
        platform,
        player,
        posterUri,
        product,
        ratingKey,
        referenceId,
        relayed,
        rowId,
        secure,
        sessionKey,
        started,
        state,
        stopped,
        thumb,
        title,
        transcodeDecision,
        user,
        userId,
        userThumb,
        watchedStatus,
        year,
      ];
}
