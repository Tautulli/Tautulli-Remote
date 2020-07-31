import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Server extends Equatable {
  final int id;
  final String plexName;
  final String tautulliId;
  final String primaryConnectionAddress;
  final String primaryConnectionProtocol;
  final String primaryConnectionDomain;
final String primaryConnectionPath;
  final String secondaryConnectionAddress;
  final String secondaryConnectionProtocol;
  final String secondaryConnectionDomain;
final String secondaryConnectionPath;
  final String deviceToken;

  Server({
    this.id,
    @required this.plexName,
    @required this.tautulliId,
    @required this.primaryConnectionAddress,
    @required this.primaryConnectionProtocol,
    @required this.primaryConnectionDomain,
    @required this.primaryConnectionPath,
    this.secondaryConnectionAddress,
    this.secondaryConnectionProtocol,
    this.secondaryConnectionDomain,
    this.secondaryConnectionPath,
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
        primaryConnectionPath,
        secondaryConnectionAddress,
        secondaryConnectionProtocol,
        secondaryConnectionDomain,
        secondaryConnectionPath,
        deviceToken,
      ];

  @override
  bool get stringify => true;
}