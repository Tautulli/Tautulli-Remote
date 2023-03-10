import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utilities/cast.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  @JsonKey(name: 'allow_guest', fromJson: Cast.castToBool)
  final bool? allowGuest;
  @JsonKey(name: 'do_notify', fromJson: Cast.castToBool)
  final bool? doNotify;
  @JsonKey(name: 'email', fromJson: Cast.castToString)
  final String? email;
  @JsonKey(name: 'filter_all', fromJson: Cast.castToString)
  final String? filterAll;
  @JsonKey(name: 'filter_movies', fromJson: Cast.castToString)
  final String? filterMovies;
  @JsonKey(name: 'filter_music', fromJson: Cast.castToString)
  final String? filterMusic;
  @JsonKey(name: 'filter_photos', fromJson: Cast.castToString)
  final String? filterPhotos;
  @JsonKey(name: 'filter_tv', fromJson: Cast.castToString)
  final String? filterTv;
  @JsonKey(name: 'friendly_name', fromJson: Cast.castToString)
  final String? friendlyName;
  @JsonKey(name: 'is_active', fromJson: Cast.castToBool)
  final bool? isActive;
  @JsonKey(name: 'is_admin', fromJson: Cast.castToBool)
  final bool? isAdmin;
  @JsonKey(name: 'is_allow_sync', fromJson: Cast.castToBool)
  final bool? isAllowSync;
  @JsonKey(name: 'is_home_user', fromJson: Cast.castToBool)
  final bool? isHomeUser;
  @JsonKey(name: 'is_restricted', fromJson: Cast.castToBool)
  final bool? isRestricted;
  @JsonKey(name: 'keep_history', fromJson: Cast.castToBool)
  final bool? keepHistory;
  @JsonKey(name: 'last_seen', fromJson: dateTimeFromEpochSeconds)
  final DateTime? lastSeen;
  @JsonKey(name: 'row_id', fromJson: Cast.castToInt)
  final int? rowId;
  @JsonKey(name: 'shared_libraries', fromJson: sharedLibrariesFromJson)
  final List<int>? sharedLibraries;
  @JsonKey(name: 'user_thumb', fromJson: Cast.castToString)
  final String? userThumb;
  @JsonKey(name: 'user_id', fromJson: Cast.castToInt)
  final int? userId;
  @JsonKey(name: 'username', fromJson: Cast.castToString)
  final String? username;

  const UserModel({
    this.allowGuest,
    this.doNotify,
    this.email,
    this.filterAll,
    this.filterMovies,
    this.filterMusic,
    this.filterPhotos,
    this.filterTv,
    this.friendlyName,
    this.isActive,
    this.isAdmin,
    this.isAllowSync,
    this.isHomeUser,
    this.isRestricted,
    this.keepHistory,
    this.lastSeen,
    this.rowId,
    this.sharedLibraries,
    this.userThumb,
    this.userId,
    this.username,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  static DateTime? dateTimeFromEpochSeconds(int? secondsSinceEpoch) {
    if (secondsSinceEpoch == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(secondsSinceEpoch * 1000);
  }

  static List<int>? sharedLibrariesFromJson(List? libraries) {
    if (libraries == null || libraries.isEmpty) return null;

    return libraries.map((item) => int.parse(item)).toList();
  }

  @override
  List<Object?> get props => [
        allowGuest,
        doNotify,
        email,
        filterAll,
        filterMovies,
        filterMusic,
        filterPhotos,
        filterTv,
        friendlyName,
        isActive,
        isAdmin,
        isAllowSync,
        isHomeUser,
        isRestricted,
        keepHistory,
        lastSeen,
        rowId,
        sharedLibraries,
        userThumb,
        userId,
        username,
      ];
}
