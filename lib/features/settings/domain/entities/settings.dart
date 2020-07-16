import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Settings extends Equatable {
  final String connectionAddress;
  final String connectionProtocol;
  final String connectionDomain;
  final String connectionUser;
  final String connectionPassword;
  final String deviceToken;

  Settings({
    @required this.connectionAddress,
    @required this.connectionProtocol,
    @required this.connectionDomain,
    @required this.connectionUser,
    @required this.connectionPassword,
    @required this.deviceToken,
  });

  @override
  List<Object> get props => [
        connectionAddress,
        connectionProtocol,
        connectionDomain,
        connectionUser,
        connectionPassword,
        deviceToken,
      ];

  @override
  bool get stringify => true;
}
