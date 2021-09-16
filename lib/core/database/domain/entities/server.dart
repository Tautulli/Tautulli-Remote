// @dart=2.9

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../data/models/custom_header_model.dart';

class Server extends Equatable {
  final int id;
  final int sortIndex;
  final String plexName;
  final String plexIdentifier;
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
  final bool primaryActive;
  final bool onesignalRegistered;
  final bool plexPass;
  final String dateFormat;
  final String timeFormat;
  final List<CustomHeaderModel> customHeaders;

  Server({
    this.id,
    this.sortIndex,
    @required this.plexName,
    @required this.plexIdentifier,
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
    @required this.primaryActive,
    @required this.onesignalRegistered,
    @required this.plexPass,
    this.dateFormat,
    this.timeFormat,
    this.customHeaders,
  });

  @override
  List<Object> get props => [
        id,
        sortIndex,
        plexName,
        plexIdentifier,
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
        primaryActive,
        onesignalRegistered,
        plexPass,
        dateFormat,
        timeFormat,
        customHeaders,
      ];

  @override
  bool get stringify => true;
}
