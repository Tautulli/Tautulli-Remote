// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_watch_time_stat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LibraryWatchTimeStatModel _$LibraryWatchTimeStatModelFromJson(
        Map<String, dynamic> json) =>
    LibraryWatchTimeStatModel(
      queryDays: Cast.castToInt(json['query_days']),
      totalPlays: Cast.castToInt(json['total_plays']),
      totalTime: Cast.castToInt(json['total_time']),
    );

Map<String, dynamic> _$LibraryWatchTimeStatModelToJson(
        LibraryWatchTimeStatModel instance) =>
    <String, dynamic>{
      'query_days': instance.queryDays,
      'total_plays': instance.totalPlays,
      'total_time': instance.totalTime,
    };
