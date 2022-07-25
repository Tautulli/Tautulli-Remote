// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_user_stat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LibraryUserStatModel _$LibraryUserStatModelFromJson(
        Map<String, dynamic> json) =>
    LibraryUserStatModel(
      friendlyName: Cast.castToString(json['friendly_name']),
      totalPlays: Cast.castToInt(json['total_plays']),
      totalTime: Cast.castToInt(json['total_time']),
      userId: Cast.castToInt(json['user_id']),
      userThumb: Cast.castToString(json['user_thumb']),
      username: Cast.castToString(json['username']),
    );

Map<String, dynamic> _$LibraryUserStatModelToJson(
        LibraryUserStatModel instance) =>
    <String, dynamic>{
      'friendly_name': instance.friendlyName,
      'total_plays': instance.totalPlays,
      'total_time': instance.totalTime,
      'user_id': instance.userId,
      'user_thumb': instance.userThumb,
      'username': instance.username,
    };
