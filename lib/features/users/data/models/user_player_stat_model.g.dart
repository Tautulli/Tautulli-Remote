// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_player_stat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPlayerStatModel _$UserPlayerStatModelFromJson(Map<String, dynamic> json) =>
    UserPlayerStatModel(
      platform: Cast.castToString(json['platform']),
      platformName: Cast.castToString(json['platform_name']),
      playerName: Cast.castToString(json['player_name']),
      resultId: Cast.castToInt(json['result_id']),
      totalPlays: Cast.castToInt(json['total_plays']),
      totalTime: Cast.castToInt(json['total_time']),
    );

Map<String, dynamic> _$UserPlayerStatModelToJson(
        UserPlayerStatModel instance) =>
    <String, dynamic>{
      'platform': instance.platform,
      'platform_name': instance.platformName,
      'player_name': instance.playerName,
      'result_id': instance.resultId,
      'total_plays': instance.totalPlays,
      'total_time': instance.totalTime,
    };
