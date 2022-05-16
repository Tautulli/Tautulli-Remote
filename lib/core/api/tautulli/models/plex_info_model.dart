import 'package:json_annotation/json_annotation.dart';

import '../../../utilities/cast.dart';

part 'plex_info_model.g.dart';

@JsonSerializable()
class PlexInfoModel {
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

  PlexInfoModel({
    required this.pmsIdentifier,
    required this.pmsIp,
    required this.pmsIsRemote,
    required this.pmsName,
    required this.pmsPlatform,
    required this.pmsPlexpass,
    required this.pmsPort,
    required this.pmsSsl,
    required this.pmsUrl,
    required this.pmsUrlManual,
    required this.pmsVersion,
  });

  factory PlexInfoModel.fromJson(Map<String, dynamic> json) =>
      _$PlexInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlexInfoModelToJson(this);
}
