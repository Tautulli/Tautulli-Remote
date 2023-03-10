import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utilities/cast.dart';

part 'library_user_stat_model.g.dart';

@JsonSerializable()
class LibraryUserStatModel {
  @JsonKey(name: 'friendly_name', fromJson: Cast.castToString)
  final String? friendlyName;
  @JsonKey(name: 'total_plays', fromJson: Cast.castToInt)
  final int? totalPlays;
  @JsonKey(name: 'total_time', fromJson: Cast.castToInt)
  final int? totalTime;
  @JsonKey(name: 'user_id', fromJson: Cast.castToInt)
  final int? userId;
  @JsonKey(name: 'user_thumb', fromJson: Cast.castToString)
  final String? userThumb;
  @JsonKey(name: 'username', fromJson: Cast.castToString)
  final String? username;

  LibraryUserStatModel({
    required this.friendlyName,
    required this.totalPlays,
    required this.totalTime,
    required this.userId,
    required this.userThumb,
    required this.username,
  });

  factory LibraryUserStatModel.fromJson(Map<String, dynamic> json) => _$LibraryUserStatModelFromJson(json);

  Map<String, dynamic> toJson() => _$LibraryUserStatModelToJson(this);
}
