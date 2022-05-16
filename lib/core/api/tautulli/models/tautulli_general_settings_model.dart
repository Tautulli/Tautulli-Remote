import 'package:json_annotation/json_annotation.dart';

import '../../../utilities/cast.dart';

part 'tautulli_general_settings_model.g.dart';

@JsonSerializable()
class TautulliGeneralSettingsModel {
  @JsonKey(name: 'date_format', fromJson: Cast.castToString)
  final String? dateFormat;
  @JsonKey(name: 'time_format', fromJson: Cast.castToString)
  final String? timeFormat;

  TautulliGeneralSettingsModel({
    this.dateFormat,
    this.timeFormat,
  });

  factory TautulliGeneralSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$TautulliGeneralSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$TautulliGeneralSettingsModelToJson(this);
}
