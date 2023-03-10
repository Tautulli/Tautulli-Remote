// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_device_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterDeviceModel _$RegisterDeviceModelFromJson(Map<String, dynamic> json) =>
    RegisterDeviceModel(
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
      serverId: Cast.castToString(json['server_id']),
      tautulliInstallType: Cast.castToString(json['tautulli_install_type']),
      tautulliBranch: Cast.castToString(json['tautulli_branch']),
      tautulliCommit: Cast.castToString(json['tautulli_commit']),
      tautulliPlatform: Cast.castToString(json['tautulli_platform']),
      tautulliPlatformDeviceName:
          Cast.castToString(json['tautulli_platform_device_name']),
      tautulliPlatformLinuxDistro:
          Cast.castToString(json['tautulli_platform_linux_distro']),
      tautulliPlatformRelease:
          Cast.castToString(json['tautulli_platform_release']),
      tautulliPlatformVersion:
          Cast.castToString(json['tautulli_platform_version']),
      tautulliPythonVersion: Cast.castToString(json['tautulli_python_version']),
      tautulliVersion: Cast.castToString(json['tautulli_version']),
    );

Map<String, dynamic> _$RegisterDeviceModelToJson(
        RegisterDeviceModel instance) =>
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
      'server_id': instance.serverId,
      'tautulli_install_type': instance.tautulliInstallType,
      'tautulli_branch': instance.tautulliBranch,
      'tautulli_commit': instance.tautulliCommit,
      'tautulli_platform': instance.tautulliPlatform,
      'tautulli_platform_device_name': instance.tautulliPlatformDeviceName,
      'tautulli_platform_linux_distro': instance.tautulliPlatformLinuxDistro,
      'tautulli_platform_release': instance.tautulliPlatformRelease,
      'tautulli_platform_version': instance.tautulliPlatformVersion,
      'tautulli_python_version': instance.tautulliPythonVersion,
      'tautulli_version': instance.tautulliVersion,
    };
