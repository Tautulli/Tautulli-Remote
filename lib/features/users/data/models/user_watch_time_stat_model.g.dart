// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_watch_time_stat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserWatchTimeStatModel _$UserWatchTimeStatModelFromJson(
        Map<String, dynamic> json) =>
    UserWatchTimeStatModel(
      queryDays: Cast.castToInt(json['query_days']),
      totalPlays: Cast.castToInt(json['total_plays']),
      totalTime: Cast.castToInt(json['total_time']),
    );

Map<String, dynamic> _$UserWatchTimeStatModelToJson(
        UserWatchTimeStatModel instance) =>
    <String, dynamic>{
      'query_days': instance.queryDays,
      'total_plays': instance.totalPlays,
      'total_time': instance.totalTime,
    };
