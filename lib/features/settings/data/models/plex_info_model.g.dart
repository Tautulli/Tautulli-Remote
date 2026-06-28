// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plex_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlexInfoModel _$PlexInfoModelFromJson(Map<String, dynamic> json) =>
    PlexInfoModel(
      pmsIdentifier: Cast.castToString(json['pms_identifier']),
      pmsIp: Cast.castToString(json['pms_ip']),
      pmsIsRemote: Cast.castToBool(json['pms_is_remote']),
      pmsName: Cast.castToString(json['pms_name']),
      pmsPlatform: Cast.castToString(json['pms_platform']),
      pmsPlexpass: Cast.castToBool(json['pms_plexpass']),
      pmsPort: Cast.castToInt(json['pms_port']),
      pmsSsl: Cast.castToBool(json['pms_ssl']),
      pmsUrl: Cast.castToString(json['pms_url']),
      pmsUrlManual: Cast.castToBool(json['pms_url_manual']),
      pmsVersion: Cast.castToString(json['pms_version']),
    );

Map<String, dynamic> _$PlexInfoModelToJson(PlexInfoModel instance) =>
    <String, dynamic>{
      'pms_identifier': instance.pmsIdentifier,
      'pms_ip': instance.pmsIp,
      'pms_is_remote': instance.pmsIsRemote,
      'pms_name': instance.pmsName,
      'pms_platform': instance.pmsPlatform,
      'pms_plexpass': instance.pmsPlexpass,
      'pms_port': instance.pmsPort,
      'pms_ssl': instance.pmsSsl,
      'pms_url': instance.pmsUrl,
      'pms_url_manual': instance.pmsUrlManual,
      'pms_version': instance.pmsVersion,
    };
