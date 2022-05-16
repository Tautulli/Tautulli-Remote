import 'package:json_annotation/json_annotation.dart';

import '../../../utilities/cast.dart';

part 'register_device_model.g.dart';

@JsonSerializable()
class RegisterDeviceModel {
  @JsonKey(name: 'pms_identifier', fromJson: Cast.castToString)
  final String? pmsIdentifier;
  @JsonKey(name: 'pms_ip', fromJson: Cast.castToString)
  final String? pmsIp;
  @JsonKey(name: 'pms_is_remote', fromJson: Cast.castToBool)
  final bool? pmsIsRemote;
  @JsonKey(name: 'pms_name', fromJson: Cast.castToString)
  final String? pmsName;
  @JsonKey(name: 'pms_platform', fromJson: Cast.castToString)
  final String? pmsPlatform;
  @JsonKey(name: 'pms_plexpass', fromJson: Cast.castToBool)
  final bool? pmsPlexpass;
  @JsonKey(name: 'pms_port', fromJson: Cast.castToInt)
  final int? pmsPort;
  @JsonKey(name: 'pms_ssl', fromJson: Cast.castToBool)
  final bool? pmsSsl;
  @JsonKey(name: 'pms_url', fromJson: Cast.castToString)
  final String? pmsUrl;
  @JsonKey(name: 'pms_url_manual', fromJson: Cast.castToBool)
  final bool? pmsUrlManual;
  @JsonKey(name: 'pms_version', fromJson: Cast.castToString)
  final String? pmsVersion;
  @JsonKey(name: 'server_id', fromJson: Cast.castToString)
  final String? serverId;
  @JsonKey(name: 'tautulli_install_type', fromJson: Cast.castToString)
  final String? tautulliInstallType;
  @JsonKey(name: 'tautulli_branch', fromJson: Cast.castToString)
  final String? tautulliBranch;
  @JsonKey(name: 'tautulli_commit', fromJson: Cast.castToString)
  final String? tautulliCommit;
  @JsonKey(name: 'tautulli_platform', fromJson: Cast.castToString)
  final String? tautulliPlatform;
  @JsonKey(name: 'tautulli_platform_device_name', fromJson: Cast.castToString)
  final String? tautulliPlatformDeviceName;
  @JsonKey(name: 'tautulli_platform_linux_distro', fromJson: Cast.castToString)
  final String? tautulliPlatformLinuxDistro;
  @JsonKey(name: 'tautulli_platform_release', fromJson: Cast.castToString)
  final String? tautulliPlatformRelease;
  @JsonKey(name: 'tautulli_platform_version', fromJson: Cast.castToString)
  final String? tautulliPlatformVersion;
  @JsonKey(name: 'tautulli_python_version', fromJson: Cast.castToString)
  final String? tautulliPythonVersion;
  @JsonKey(name: 'tautulli_version', fromJson: Cast.castToString)
  final String? tautulliVersion;

  RegisterDeviceModel({
    this.pmsIdentifier,
    this.pmsIp,
    this.pmsIsRemote,
    this.pmsName,
    this.pmsPlatform,
    this.pmsPlexpass,
    this.pmsPort,
    this.pmsSsl,
    this.pmsUrl,
    this.pmsUrlManual,
    this.pmsVersion,
    this.serverId,
    this.tautulliInstallType,
    this.tautulliBranch,
    this.tautulliCommit,
    this.tautulliPlatform,
    this.tautulliPlatformDeviceName,
    this.tautulliPlatformLinuxDistro,
    this.tautulliPlatformRelease,
    this.tautulliPlatformVersion,
    this.tautulliPythonVersion,
    this.tautulliVersion,
  });

  factory RegisterDeviceModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterDeviceModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterDeviceModelToJson(this);
}
