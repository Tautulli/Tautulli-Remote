// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tautulli_general_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TautulliGeneralSettingsModel _$TautulliGeneralSettingsModelFromJson(
        Map<String, dynamic> json) =>
    TautulliGeneralSettingsModel(
      dateFormat: Cast.castToString(json['date_format']),
      timeFormat: Cast.castToString(json['time_format']),
    );

Map<String, dynamic> _$TautulliGeneralSettingsModelToJson(
        TautulliGeneralSettingsModel instance) =>
    <String, dynamic>{
      'date_format': instance.dateFormat,
      'time_format': instance.timeFormat,
    };
