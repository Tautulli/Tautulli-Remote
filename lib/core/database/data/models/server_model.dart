// @dart=2.9

import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:validators/sanitizers.dart';

import '../../domain/entities/server.dart';
import 'custom_header_model.dart';

class ServerModel extends Server {
  ServerModel({
    int id,
    int sortIndex,
    @required String plexName,
    @required String plexIdentifier,
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
    @required bool onesignalRegistered,
    @required bool plexPass,
    String dateFormat,
    String timeFormat,
    List<CustomHeaderModel> customHeaders,
  }) : super(
          id: id,
          sortIndex: sortIndex,
          plexName: plexName,
          plexIdentifier: plexIdentifier,
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
          onesignalRegistered: onesignalRegistered,
          plexPass: plexPass,
          dateFormat: dateFormat,
          timeFormat: timeFormat,
          customHeaders: customHeaders,
        );

  ServerModel copyWith({
    int id,
    int sortIndex,
    String plexName,
    String plexIdentifier,
    String tautulliId,
    String primaryConnectionAddress,
    String primaryConnectionProtocol,
    String primaryConnectionDomain,
    String primaryConnectionPath,
    String secondaryConnectionAddress,
    String secondaryConnectionProtocol,
    String secondaryConnectionDomain,
    String secondaryConnectionPath,
    String deviceToken,
    bool primaryActive,
    bool onesignalRegistered,
    bool plexPass,
    String dateFormat,
    String timeFormat,
    List<CustomHeaderModel> customHeaders,
  }) {
    return ServerModel(
      id: id ?? this.id,
      sortIndex: sortIndex ?? this.sortIndex,
      plexName: plexName ?? this.plexName,
      plexIdentifier: plexIdentifier ?? this.plexIdentifier,
      tautulliId: tautulliId ?? this.tautulliId,
      primaryConnectionAddress:
          primaryConnectionAddress ?? this.primaryConnectionAddress,
      primaryConnectionProtocol:
          primaryConnectionProtocol ?? this.primaryConnectionProtocol,
      primaryConnectionDomain:
          primaryConnectionDomain ?? this.primaryConnectionDomain,
      primaryConnectionPath:
          primaryConnectionPath ?? this.primaryConnectionPath,
      secondaryConnectionAddress:
          secondaryConnectionAddress ?? this.secondaryConnectionAddress,
      secondaryConnectionProtocol:
          secondaryConnectionProtocol ?? this.secondaryConnectionProtocol,
      secondaryConnectionDomain:
          secondaryConnectionDomain ?? this.secondaryConnectionDomain,
      secondaryConnectionPath:
          secondaryConnectionPath ?? this.secondaryConnectionPath,
      deviceToken: deviceToken ?? this.deviceToken,
      primaryActive: primaryActive ?? this.primaryActive,
      onesignalRegistered: onesignalRegistered ?? this.onesignalRegistered,
      plexPass: plexPass ?? this.plexPass,
      dateFormat: dateFormat ?? this.dateFormat,
      timeFormat: timeFormat ?? this.timeFormat,
      customHeaders: customHeaders ?? this.customHeaders,
    );
  }

  // Create Settings from JSON data
  factory ServerModel.fromJson(Map<String, dynamic> serverJson) {
    bool primaryActiveBool = toBoolean(serverJson['primary_active'].toString());
    bool onesignalRegisteredBool =
        toBoolean(serverJson['onesignal_registered'].toString());
    bool plexPass = toBoolean(serverJson['plex_plexpass'].toString());

    Map<String, dynamic> decodedCustomHeaders =
        serverJson['custom_headers'] != null
            ? json.decode(
                serverJson['custom_headers'],
              )
            : {};
    List<CustomHeaderModel> customHeaderList = [];
    decodedCustomHeaders.forEach((key, value) {
      customHeaderList.add(CustomHeaderModel(
        key: key,
        value: value,
      ));
    });

    return ServerModel(
      id: serverJson['id'],
      sortIndex: serverJson['sort_index'],
      plexName: serverJson['plex_name'],
      plexIdentifier: serverJson['plex_identifier'],
      tautulliId: serverJson['tautulli_id'],
      primaryConnectionAddress: serverJson['primary_connection_address'],
      primaryConnectionProtocol: serverJson['primary_connection_protocol'],
      primaryConnectionDomain: serverJson['primary_connection_domain'],
      primaryConnectionPath: serverJson['primary_connection_path'],
      secondaryConnectionAddress: serverJson['secondary_connection_address'],
      secondaryConnectionProtocol: serverJson['secondary_connection_protocol'],
      secondaryConnectionDomain: serverJson['secondary_connection_domain'],
      secondaryConnectionPath: serverJson['secondary_connection_path'],
      deviceToken: serverJson['device_token'],
      primaryActive: primaryActiveBool,
      onesignalRegistered: onesignalRegisteredBool,
      plexPass: plexPass,
      dateFormat: serverJson['date_format'],
      timeFormat: serverJson['time_format'],
      customHeaders: customHeaderList,
    );
  }

  // Convert Settings to JSON to make it easier when we store it in the database
  Map<String, dynamic> toJson() {
    int primaryActiveInt;
    int onesignalRegisteredInt;
    int plexPassInt;
    Map<String, dynamic> customHeaderMap = {};

    switch (primaryActive) {
      case (false):
        primaryActiveInt = 0;
        break;
      case (true):
        primaryActiveInt = 1;
        break;
    }

    switch (onesignalRegistered) {
      case (false):
        onesignalRegisteredInt = 0;
        break;
      case (true):
        onesignalRegisteredInt = 1;
        break;
    }

    switch (plexPass) {
      case (false):
        plexPassInt = 0;
        break;
      case (true):
        plexPassInt = 1;
        break;
    }

    if (customHeaders != null && customHeaders.isNotEmpty) {
      customHeaders.forEach((customHeader) {
        customHeaderMap['${customHeader.key}'] = '${customHeader.value}';
      });
    }

    return {
      'id': id,
      'sort_index': sortIndex,
      'plex_name': plexName,
      'plex_identifier': plexIdentifier,
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
      'onesignal_registered': onesignalRegisteredInt,
      'plex_pass': plexPassInt,
      'date_format': dateFormat,
      'time_format': timeFormat,
      'custom_headers': json.encode(customHeaderMap),
    };
  }
}
