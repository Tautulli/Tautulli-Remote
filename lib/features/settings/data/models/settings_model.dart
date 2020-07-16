import 'package:meta/meta.dart';

import '../../domain/entities/settings.dart';

class SettingsModel extends Settings {
  SettingsModel({
    @required String connectionAddress,
    @required String connectionProtocol,
    @required String connectionDomain,
    @required String connectionUser,
    @required String connectionPassword,
    @required String deviceToken,
  }) : super(
          connectionAddress: connectionAddress,
          connectionProtocol: connectionProtocol,
          connectionDomain: connectionDomain,
          connectionUser: connectionUser,
          connectionPassword: connectionPassword,
          deviceToken: deviceToken,
        );
}
