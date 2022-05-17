import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utilities/cast.dart';

part 'user_watch_time_stat_model.g.dart';

@JsonSerializable()
class UserWatchTimeStatModel {
  @JsonKey(name: 'query_days', fromJson: Cast.castToInt)
  final int? queryDays;
  @JsonKey(name: 'total_plays', fromJson: Cast.castToInt)
  final int? totalPlays;
  @JsonKey(name: 'total_time', fromJson: Cast.castToInt)
  final int? totalTime;

  UserWatchTimeStatModel({
    required this.queryDays,
    required this.totalPlays,
    required this.totalTime,
  });

  factory UserWatchTimeStatModel.fromJson(Map<String, dynamic> json) =>
      _$UserWatchTimeStatModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserWatchTimeStatModelToJson(this);
}
