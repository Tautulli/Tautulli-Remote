// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnnouncementModel _$AnnouncementModelFromJson(Map<String, dynamic> json) =>
    AnnouncementModel(
      actionUrl: json['actionUrl'] as String?,
      body: json['body'] as String,
      date: json['date'] as String,
      id: json['id'] as int,
      platform: AnnouncementModel.castToPlatform(json['platform'] as String?),
      title: json['title'] as String,
    );

Map<String, dynamic> _$AnnouncementModelToJson(AnnouncementModel instance) =>
    <String, dynamic>{
      'actionUrl': instance.actionUrl,
      'body': instance.body,
      'date': instance.date,
      'id': instance.id,
      'platform': _$DevicePlatformEnumMap[instance.platform]!,
      'title': instance.title,
    };

const _$DevicePlatformEnumMap = {
  DevicePlatform.all: 'all',
  DevicePlatform.android: 'android',
  DevicePlatform.ios: 'ios',
};
