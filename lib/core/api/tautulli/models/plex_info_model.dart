import 'package:json_annotation/json_annotation.dart';

import '../../../utilities/cast.dart';

part 'plex_info_model.g.dart';

@JsonSerializable()
class PlexInfoModel {
  @JsonKey(name: 'pms_identifier', fromJson: Cast.castToString)
  String? pmsIdentifier;
  @JsonKey(name: 'pms_ip', fromJson: Cast.castToString)
  String? pmsIp;
  @JsonKey(name: 'pms_is_remote', fromJson: Cast.castToBool)
  bool? pmsIsRemote;
  @JsonKey(name: 'pms_name', fromJson: Cast.castToString)
  String? pmsName;
  @JsonKey(name: 'pms_platform', fromJson: Cast.castToString)
  String? pmsPlatform;
  @JsonKey(name: 'pms_plexpass', fromJson: Cast.castToBool)
  bool? pmsPlexpass;
  @JsonKey(name: 'pms_port', fromJson: Cast.castToInt)
  int? pmsPort;
  @JsonKey(name: 'pms_ssl', fromJson: Cast.castToBool)
  bool? pmsSsl;
  @JsonKey(name: 'pms_url', fromJson: Cast.castToString)
  String? pmsUrl;
  @JsonKey(name: 'pms_url_manual', fromJson: Cast.castToBool)
  bool? pmsUrlManual;
  @JsonKey(name: 'pms_version', fromJson: Cast.castToString)
  String? pmsVersion;

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
