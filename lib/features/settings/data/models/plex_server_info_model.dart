import '../../../../core/helpers/value_helper.dart';
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
      pmsIdentifier: ValueHelper.cast(
        value: json['pms_identifier'],
        type: CastType.string,
      ),
      pmsIp: ValueHelper.cast(
        value: json['pms_ip'],
        type: CastType.string,
      ),
      pmsIsRemote: ValueHelper.cast(
        value: json['pms_is_remote'],
        type: CastType.int,
      ),
      pmsName: ValueHelper.cast(
        value: json['pms_name'],
        type: CastType.string,
      ),
      pmsPlatform: ValueHelper.cast(
        value: json['pms_platform'],
        type: CastType.string,
      ),
      pmsPlexpass: ValueHelper.cast(
        value: json['pms_plexpass'],
        type: CastType.int,
      ),
      pmsPort: ValueHelper.cast(
        value: json['pms_port'],
        type: CastType.int,
      ),
      pmsSsl: ValueHelper.cast(
        value: json['pms_ssl'],
        type: CastType.int,
      ),
      pmsUrl: ValueHelper.cast(
        value: json['pms_url'],
        type: CastType.string,
      ),
      pmsUrlManual: ValueHelper.cast(
        value: json['pms_url_manual'],
        type: CastType.int,
      ),
      pmsVersion: ValueHelper.cast(
        value: json['pms_version'],
        type: CastType.string,
      ),
    );
  }
}
