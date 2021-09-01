// @dart=2.9

import 'package:equatable/equatable.dart';

abstract class PlexServerInfo extends Equatable {
  final String pmsIdentifier;
  final String pmsIp;
  final int pmsIsRemote;
  final String pmsName;
  final String pmsPlatform;
  final int pmsPlexpass;
  final int pmsPort;
  final int pmsSsl;
  final String pmsUrl;
  final int pmsUrlManual;
  final String pmsVersion;

  PlexServerInfo({
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
  });

  @override
  List<Object> get props => [
        pmsIdentifier,
        pmsIp,
        pmsIsRemote,
        pmsName,
        pmsPlatform,
        pmsPlexpass,
        pmsPort,
        pmsSsl,
        pmsUrl,
        pmsUrlManual,
        pmsVersion,
      ];

  @override
  bool get stringify => true;
}
