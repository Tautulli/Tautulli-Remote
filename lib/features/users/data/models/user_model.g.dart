// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      allowGuest: Cast.castToBool(json['allow_guest']),
      doNotify: Cast.castToBool(json['do_notify']),
      email: Cast.castToString(json['email']),
      filterAll: Cast.castToString(json['filter_all']),
      filterMovies: Cast.castToString(json['filter_movies']),
      filterMusic: Cast.castToString(json['filter_music']),
      filterPhotos: Cast.castToString(json['filter_photos']),
      filterTv: Cast.castToString(json['filter_tv']),
      friendlyName: Cast.castToString(json['friendly_name']),
      isActive: Cast.castToBool(json['is_active']),
      isAdmin: Cast.castToBool(json['is_admin']),
      isAllowSync: Cast.castToBool(json['is_allow_sync']),
      isHomeUser: Cast.castToBool(json['is_home_user']),
      isRestricted: Cast.castToBool(json['is_restricted']),
      keepHistory: Cast.castToBool(json['keep_history']),
      lastSeen: UserModel.dateTimeFromEpochSeconds(json['last_seen'] as int?),
      rowId: Cast.castToInt(json['row_id']),
      sharedLibraries:
          UserModel.sharedLibrariesFromJson(json['shared_libraries'] as List?),
      userThumb: Cast.castToString(json['user_thumb']),
      userId: Cast.castToInt(json['user_id']),
      username: Cast.castToString(json['username']),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'allow_guest': instance.allowGuest,
      'do_notify': instance.doNotify,
      'email': instance.email,
      'filter_all': instance.filterAll,
      'filter_movies': instance.filterMovies,
      'filter_music': instance.filterMusic,
      'filter_photos': instance.filterPhotos,
      'filter_tv': instance.filterTv,
      'friendly_name': instance.friendlyName,
      'is_active': instance.isActive,
      'is_admin': instance.isAdmin,
      'is_allow_sync': instance.isAllowSync,
      'is_home_user': instance.isHomeUser,
      'is_restricted': instance.isRestricted,
      'keep_history': instance.keepHistory,
      'last_seen': instance.lastSeen?.toIso8601String(),
      'row_id': instance.rowId,
      'shared_libraries': instance.sharedLibraries,
      'user_thumb': instance.userThumb,
      'user_id': instance.userId,
      'username': instance.username,
    };
