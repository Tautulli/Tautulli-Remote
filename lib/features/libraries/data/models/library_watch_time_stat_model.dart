import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utilities/cast.dart';

part 'library_watch_time_stat_model.g.dart';

@JsonSerializable()
class LibraryWatchTimeStatModel {
  @JsonKey(name: 'query_days', fromJson: Cast.castToInt)
  final int? queryDays;
  @JsonKey(name: 'total_plays', fromJson: Cast.castToInt)
  final int? totalPlays;
  @JsonKey(name: 'total_time', fromJson: Cast.castToInt)
  final int? totalTime;

  LibraryWatchTimeStatModel({
    required this.queryDays,
    required this.totalPlays,
    required this.totalTime,
  });

  factory LibraryWatchTimeStatModel.fromJson(Map<String, dynamic> json) => _$LibraryWatchTimeStatModelFromJson(json);

  Map<String, dynamic> toJson() => _$LibraryWatchTimeStatModelToJson(this);
}
