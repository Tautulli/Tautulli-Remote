import '../../domain/entities/plex_server_info.dart';

class PlexServerInfoModel extends PlexServerInfo {
  PlexServerInfoModel({
    final String pmsIdentifier,
    final String pmsIp,
    final int pmsIsRemote,
    final String pmsName,
    final String pmsPlatform,
    final int pmsPlexpass,
    final int pmsPort,
    final int pmsSsl,
    final String pmsUrl,
    final int pmsUrlManual,
    final String pmsVersion,
  }) : super(
          pmsIdentifier: pmsIdentifier,
          pmsIp: pmsIp,
          pmsIsRemote: pmsIsRemote,
          pmsName: pmsName,
          pmsPlatform: pmsPlatform,
          pmsPlexpass: pmsPlexpass,
          pmsPort: pmsPort,
          pmsSsl: pmsSsl,
          pmsUrl: pmsUrl,
          pmsUrlManual: pmsUrlManual,
          pmsVersion: pmsVersion,
        );

  factory PlexServerInfoModel.fromJson(Map<String, dynamic> json) {
    return PlexServerInfoModel(
      pmsIdentifier: json['pms_identifier'],
      pmsIp: json['pms_ip'],
      pmsIsRemote: json['pms_is_remote'],
      pmsName: json['pms_name'],
      pmsPlatform: json['pms_platform'],
      pmsPlexpass: json['pms_plexpass'],
      pmsPort: json['pms_port'],
      pmsSsl: json['pms_ssl'],
      pmsUrl: json['pms_url'],
      pmsUrlManual: json['pms_url_manual'],
      pmsVersion: json['pms_version'],
    );
  }
}
