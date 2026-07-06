import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utilities/cast.dart';

part 'tautulli_date_formats_model.g.dart';

@JsonSerializable()
class TautulliDateFormatsModel {
  @JsonKey(name: 'date_format', fromJson: Cast.castToString)
  final String? dateFormat;
  @JsonKey(name: 'time_format', fromJson: Cast.castToString)
  final String? timeFormat;

  TautulliDateFormatsModel({
    this.dateFormat,
    this.timeFormat,
  });

  factory TautulliDateFormatsModel.fromJson(Map<String, dynamic> json) =>
      _$TautulliDateFormatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$TautulliDateFormatsModelToJson(this);
}
