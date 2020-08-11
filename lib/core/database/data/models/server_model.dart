import 'package:meta/meta.dart';
import 'package:validators/sanitizers.dart';

import '../../domain/entities/server.dart';

class ServerModel extends Server {
  ServerModel({
    int id,
    @required String plexName,
    @required String tautulliId,
    @required String primaryConnectionAddress,
    @required String primaryConnectionProtocol,
    @required String primaryConnectionDomain,
    @required String primaryConnectionPath,
    String secondaryConnectionAddress,
    String secondaryConnectionProtocol,
    String secondaryConnectionDomain,
    String secondaryConnectionPath,
    @required String deviceToken,
    @required bool primaryActive,
  }) : super(
          id: id,
          plexName: plexName,
          tautulliId: tautulliId,
          primaryConnectionAddress: primaryConnectionAddress,
          primaryConnectionProtocol: primaryConnectionProtocol,
          primaryConnectionDomain: primaryConnectionDomain,
          primaryConnectionPath: primaryConnectionPath,
          secondaryConnectionAddress: secondaryConnectionAddress,
          secondaryConnectionProtocol: secondaryConnectionProtocol,
          secondaryConnectionDomain: secondaryConnectionDomain,
          secondaryConnectionPath: secondaryConnectionPath,
          deviceToken: deviceToken,
          primaryActive: primaryActive,
        );

  // Create Settings from JSON data
  factory ServerModel.fromJson(Map<String, dynamic> json) {
    bool primaryActiveBool = toBoolean(json['primary_active'].toString());

    return ServerModel(
      id: json['id'],
      plexName: json['plex_name'],
      tautulliId: json['tautulli_id'],
      primaryConnectionAddress: json['primary_connection_address'],
      primaryConnectionProtocol: json['primary_connection_protocol'],
      primaryConnectionDomain: json['primary_connection_domain'],
      primaryConnectionPath: json['primary_connection_path'],
      secondaryConnectionAddress: json['secondary_connection_address'],
      secondaryConnectionProtocol: json['secondary_connection_protocol'],
      secondaryConnectionDomain: json['secondary_connection_domain'],
      secondaryConnectionPath: json['secondary_connection_path'],
      deviceToken: json['device_token'],
      primaryActive: primaryActiveBool,
    );
  }

  // Convert Settings to JSON to make it easier when we store it in the database
  Map<String, dynamic> toJson() {
    int primaryActiveInt;

    switch (primaryActive) {
      case (false):
        primaryActiveInt = 0;
        break;
      case (true):
        primaryActiveInt = 1;
        break;
    }

    return {
      'id': id,
      'plex_name': plexName,
      'tautulli_id': tautulliId,
      'primary_connection_address': primaryConnectionAddress,
      'primary_connection_protocol': primaryConnectionProtocol,
      'primary_connection_domain': primaryConnectionDomain,
      'primary_connection_path': primaryConnectionPath,
      'secondary_connection_address': secondaryConnectionAddress,
      'secondary_connection_protocol': secondaryConnectionProtocol,
      'secondary_connection_domain': secondaryConnectionDomain,
      'secondary_connection_path': secondaryConnectionPath,
      'device_token': deviceToken,
      'primary_active': primaryActiveInt,
    };
  }
}
