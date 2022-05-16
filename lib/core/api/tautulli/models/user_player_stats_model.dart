import 'package:json_annotation/json_annotation.dart';

import '../../../utilities/cast.dart';

part 'user_player_stats_model.g.dart';

@JsonSerializable()
class UserPlayerStatsModel {
  @JsonKey(name: 'platform_type', fromJson: Cast.castToString)
  final String? platformType;
  @JsonKey(name: 'player_name', fromJson: Cast.castToString)
  final String? playerName;
  @JsonKey(name: 'result_id', fromJson: Cast.castToInt)
  final int? resultId;
  @JsonKey(name: 'total_plays', fromJson: Cast.castToInt)
  final int? totalPlays;
  @JsonKey(name: 'total_time', fromJson: Cast.castToInt)
  final int? totalTime;

  UserPlayerStatsModel({
    required this.platformType,
    required this.playerName,
    required this.resultId,
    required this.totalPlays,
    required this.totalTime,
  });

  factory UserPlayerStatsModel.fromJson(Map<String, dynamic> json) =>
      _$UserPlayerStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserPlayerStatsModelToJson(this);
}
