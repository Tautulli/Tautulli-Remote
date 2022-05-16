// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_player_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPlayerStatsModel _$UserPlayerStatsModelFromJson(
        Map<String, dynamic> json) =>
    UserPlayerStatsModel(
      platformType: Cast.castToString(json['platform_type']),
      playerName: Cast.castToString(json['player_name']),
      resultId: Cast.castToInt(json['result_id']),
      totalPlays: Cast.castToInt(json['total_plays']),
      totalTime: Cast.castToInt(json['total_time']),
    );

Map<String, dynamic> _$UserPlayerStatsModelToJson(
        UserPlayerStatsModel instance) =>
    <String, dynamic>{
      'platform_type': instance.platformType,
      'player_name': instance.playerName,
      'result_id': instance.resultId,
      'total_plays': instance.totalPlays,
      'total_time': instance.totalTime,
    };
