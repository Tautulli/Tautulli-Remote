import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Server extends Equatable {
  final int id;
  final String plexName;
  final String tautulliId;
  final String primaryConnectionAddress;
  final String primaryConnectionProtocol;
  final String primaryConnectionDomain;
  final String primaryConnectionUser;
  final String primaryConnectionPassword;
  final String secondaryConnectionAddress;
  final String secondaryConnectionProtocol;
  final String secondaryConnectionDomain;
  final String secondaryConnectionUser;
  final String secondaryConnectionPassword;
  final String deviceToken;

  Server({
    this.id,
    @required this.plexName,
    @required this.tautulliId,
    @required this.primaryConnectionAddress,
    @required this.primaryConnectionProtocol,
    @required this.primaryConnectionDomain,
    this.primaryConnectionUser,
    this.primaryConnectionPassword,
    this.secondaryConnectionAddress,
    this.secondaryConnectionProtocol,
    this.secondaryConnectionDomain,
    this.secondaryConnectionUser,
    this.secondaryConnectionPassword,
    @required this.deviceToken,
  });

  @override
  List<Object> get props => [
        id,
        plexName,
        tautulliId,
        primaryConnectionAddress,
        primaryConnectionProtocol,
        primaryConnectionDomain,
        primaryConnectionUser,
        primaryConnectionPassword,
        secondaryConnectionAddress,
        secondaryConnectionProtocol,
        secondaryConnectionDomain,
        secondaryConnectionUser,
        secondaryConnectionPassword,
        deviceToken,
      ];

  @override
  bool get stringify => true;
}
