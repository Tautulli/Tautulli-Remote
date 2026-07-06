// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tautulli_date_formats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TautulliDateFormatsModel _$TautulliDateFormatsModelFromJson(
  Map<String, dynamic> json,
) => TautulliDateFormatsModel(
  dateFormat: Cast.castToString(json['date_format']),
  timeFormat: Cast.castToString(json['time_format']),
);

Map<String, dynamic> _$TautulliDateFormatsModelToJson(
  TautulliDateFormatsModel instance,
) => <String, dynamic>{
  'date_format': instance.dateFormat,
  'time_format': instance.timeFormat,
};
