import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utilities/cast.dart';

part 'user_player_stat_model.g.dart';

@JsonSerializable()
class UserPlayerStatModel {
  @JsonKey(name: 'platform', fromJson: Cast.castToString)
  final String? platform;
  @JsonKey(name: 'platform_name', fromJson: Cast.castToString)
  final String? platformName;
  @JsonKey(name: 'player_name', fromJson: Cast.castToString)
  final String? playerName;
  @JsonKey(name: 'result_id', fromJson: Cast.castToInt)
  final int? resultId;
  @JsonKey(name: 'total_plays', fromJson: Cast.castToInt)
  final int? totalPlays;
  @JsonKey(name: 'total_time', fromJson: Cast.castToInt)
  final int? totalTime;

  UserPlayerStatModel({
    required this.platform,
    required this.platformName,
    required this.playerName,
    required this.resultId,
    required this.totalPlays,
    required this.totalTime,
  });

  factory UserPlayerStatModel.fromJson(Map<String, dynamic> json) =>
      _$UserPlayerStatModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserPlayerStatModelToJson(this);
}
