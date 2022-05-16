// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_watch_time_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserWatchTimeStatsModel _$UserWatchTimeStatsModelFromJson(
        Map<String, dynamic> json) =>
    UserWatchTimeStatsModel(
      queryDays: Cast.castToInt(json['query_days']),
      totalPlays: Cast.castToInt(json['total_plays']),
      totalTime: Cast.castToInt(json['total_time']),
    );

Map<String, dynamic> _$UserWatchTimeStatsModelToJson(
        UserWatchTimeStatsModel instance) =>
    <String, dynamic>{
      'query_days': instance.queryDays,
      'total_plays': instance.totalPlays,
      'total_time': instance.totalTime,
    };
