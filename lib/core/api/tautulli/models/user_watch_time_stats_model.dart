import 'package:json_annotation/json_annotation.dart';

import '../../../utilities/cast.dart';

part 'user_watch_time_stats_model.g.dart';

@JsonSerializable()
class UserWatchTimeStatsModel {
  @JsonKey(name: 'query_days', fromJson: Cast.castToInt)
  final int? queryDays;
  @JsonKey(name: 'total_plays', fromJson: Cast.castToInt)
  final int? totalPlays;
  @JsonKey(name: 'total_time', fromJson: Cast.castToInt)
  final int? totalTime;

  UserWatchTimeStatsModel({
    required this.queryDays,
    required this.totalPlays,
    required this.totalTime,
  });

  factory UserWatchTimeStatsModel.fromJson(Map<String, dynamic> json) =>
      _$UserWatchTimeStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserWatchTimeStatsModelToJson(this);
}
