import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/types/tautulli_types.dart';
import '../../../../core/utilities/cast.dart';

part 'user_table_model.g.dart';

@JsonSerializable()
class UserTableModel extends Equatable {
  @JsonKey(name: 'allow_guest', fromJson: Cast.castToBool)
  final bool? allowGuest;
  @JsonKey(name: 'do_notify', fromJson: Cast.castToBool)
  final bool? doNotify;
  @JsonKey(name: 'duration', fromJson: Cast.castToInt)
  final int? duration;
  @JsonKey(name: 'email', fromJson: Cast.castToString)
  final String? email;
  @JsonKey(name: 'friendly_name', fromJson: Cast.castToString)
  final String? friendlyName;
  @JsonKey(name: 'guid', fromJson: Cast.castToString)
  final String? guid;
  @JsonKey(name: 'history_row_id', fromJson: Cast.castToInt)
  final int? historyRowId;
  @JsonKey(name: 'ip_address', fromJson: Cast.castToString)
  final String? ipAddress;
  @JsonKey(name: 'is_active', fromJson: Cast.castToBool)
  final bool? isActive;
  @JsonKey(name: 'keep_history', fromJson: Cast.castToBool)
  final bool? keepHistory;
  @JsonKey(name: 'last_played', fromJson: Cast.castToString)
  final String? lastPlayed;
  @JsonKey(name: 'last_seen', fromJson: dateTimeFromEpochSeconds)
  final DateTime? lastSeen;
  @JsonKey(name: 'live', fromJson: Cast.castToBool)
  final bool? live;
  @JsonKey(name: 'media_index', fromJson: Cast.castToInt)
  final int? mediaIndex;
  @JsonKey(name: 'media_type', fromJson: Cast.castStringToMediaType)
  final MediaType? mediaType;
  @JsonKey(name: 'originally_available_at', fromJson: Cast.castToString)
  final String? originallyAvailableAt;
  @JsonKey(name: 'parent_media_index', fromJson: Cast.castToInt)
  final int? parentMediaIndex;
  @JsonKey(name: 'parent_title', fromJson: Cast.castToString)
  final String? parentTitle;
  @JsonKey(name: 'platform', fromJson: Cast.castToString)
  final String? platform;
  @JsonKey(name: 'player', fromJson: Cast.castToString)
  final String? player;
  @JsonKey(name: 'plays', fromJson: Cast.castToInt)
  final int? plays;
  @JsonKey(name: 'rating_key', fromJson: Cast.castToInt)
  final int? ratingKey;
  @JsonKey(name: 'row_id', fromJson: Cast.castToInt)
  final int? rowId;
  @JsonKey(name: 'thumb', fromJson: Cast.castToString)
  final String? thumb;
  @JsonKey(name: 'title', fromJson: Cast.castToString)
  final String? title;
  @JsonKey(
      name: 'transcode_decision', fromJson: Cast.castStringToStreamDecision)
  final StreamDecision? transcodeDecision;
  @JsonKey(name: 'user_id', fromJson: Cast.castToInt)
  final int? userId;
  @JsonKey(name: 'user_thumb', fromJson: Cast.castToString)
  final String? userThumb;
  @JsonKey(name: 'username', fromJson: Cast.castToString)
  final String? username;
  @JsonKey(name: 'year', fromJson: Cast.castToInt)
  final int? year;

  const UserTableModel({
    this.allowGuest,
    this.doNotify,
    this.duration,
    this.friendlyName,
    this.username,
    this.title,
    this.email,
    this.guid,
    this.historyRowId,
    this.ipAddress,
    this.isActive,
    this.keepHistory,
    this.lastPlayed,
    this.lastSeen,
    this.live,
    this.mediaIndex,
    this.mediaType,
    this.originallyAvailableAt,
    this.parentMediaIndex,
    this.parentTitle,
    this.platform,
    this.player,
    this.plays,
    this.ratingKey,
    this.rowId,
    this.thumb,
    this.transcodeDecision,
    this.userId,
    this.userThumb,
    this.year,
  });

  factory UserTableModel.fromJson(Map<String, dynamic> json) =>
      _$UserTableModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserTableModelToJson(this);

  static DateTime? dateTimeFromEpochSeconds(int? secondsSinceEpoch) {
    if (secondsSinceEpoch == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(secondsSinceEpoch * 1000);
  }

  static List<int>? sharedLibrariesFromJson(String? libraries) {
    if (libraries == null) return null;

    return libraries.split(';').map(int.parse).toList();
  }

  @override
  List<Object?> get props => [
        allowGuest,
        doNotify,
        duration,
        friendlyName,
        username,
        title,
        email,
        guid,
        historyRowId,
        ipAddress,
        isActive,
        keepHistory,
        lastPlayed,
        lastSeen,
        live,
        mediaIndex,
        mediaType,
        originallyAvailableAt,
        parentMediaIndex,
        parentTitle,
        platform,
        player,
        plays,
        ratingKey,
        rowId,
        thumb,
        transcodeDecision,
        userId,
        userThumb,
        year,
      ];
}
