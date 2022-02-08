import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../features/settings/data/models/custom_header_model.dart';
import '../../../utilities/cast.dart';

part 'server_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ServerModel extends Equatable {
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'sort_index')
  final int sortIndex;
  @JsonKey(name: 'plex_name')
  final String plexName;
  @JsonKey(name: 'plex_identifier')
  final String plexIdentifier;
  @JsonKey(name: 'tautulli_id')
  final String tautulliId;
  @JsonKey(name: 'primary_connection_address')
  final String primaryConnectionAddress;
  @JsonKey(name: 'primary_connection_protocol')
  final String primaryConnectionProtocol;
  @JsonKey(name: 'primary_connection_domain')
  final String primaryConnectionDomain;
  @JsonKey(name: 'primary_connection_path')
  final String? primaryConnectionPath;
  @JsonKey(name: 'secondary_connection_address')
  final String? secondaryConnectionAddress;
  @JsonKey(name: 'secondary_connection_protocol')
  final String? secondaryConnectionProtocol;
  @JsonKey(name: 'secondary_connection_domain')
  final String? secondaryConnectionDomain;
  @JsonKey(name: 'secondary_connection_path')
  final String? secondaryConnectionPath;
  @JsonKey(name: 'device_token')
  final String deviceToken;
  @JsonKey(
    name: 'primary_active',
    fromJson: Cast.castToBool,
    toJson: Cast.castToInt,
  )
  final bool? primaryActive;
  @JsonKey(
    name: 'onesignal_registered',
    fromJson: Cast.castToBool,
    toJson: Cast.castToInt,
  )
  final bool? oneSignalRegistered;
  @JsonKey(
    name: 'plex_pass',
    fromJson: Cast.castToBool,
    toJson: Cast.castToInt,
  )
  final bool? plexPass;
  @JsonKey(name: 'date_format')
  final String? dateFormat;
  @JsonKey(name: 'time_format')
  final String? timeFormat;
  @JsonKey(
    name: 'custom_headers',
    fromJson: _customHeadersFromJson,
    toJson: _customHeadersToJson,
  )
  final List<CustomHeaderModel> customHeaders;

  const ServerModel({
    this.id,
    required this.sortIndex,
    required this.plexName,
    required this.plexIdentifier,
    required this.tautulliId,
    required this.primaryConnectionAddress,
    required this.primaryConnectionProtocol,
    required this.primaryConnectionDomain,
    this.primaryConnectionPath,
    this.secondaryConnectionAddress,
    this.secondaryConnectionProtocol,
    this.secondaryConnectionDomain,
    this.secondaryConnectionPath,
    required this.deviceToken,
    required this.primaryActive,
    required this.oneSignalRegistered,
    required this.plexPass,
    this.dateFormat,
    this.timeFormat,
    required this.customHeaders,
  });

  ServerModel copyWith({
    int? id,
    int? sortIndex,
    String? plexName,
    String? plexIdentifier,
    String? tautulliId,
    String? primaryConnectionAddress,
    String? primaryConnectionProtocol,
    String? primaryConnectionDomain,
    String? primaryConnectionPath,
    String? secondaryConnectionAddress,
    String? secondaryConnectionProtocol,
    String? secondaryConnectionDomain,
    String? secondaryConnectionPath,
    String? deviceToken,
    bool? primaryActive,
    bool? oneSignalRegistered,
    bool? plexPass,
    String? dateFormat,
    String? timeFormat,
    List<CustomHeaderModel>? customHeaders,
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
      oneSignalRegistered: oneSignalRegistered ?? this.oneSignalRegistered,
      plexPass: plexPass ?? this.plexPass,
      dateFormat: dateFormat ?? this.dateFormat,
      timeFormat: timeFormat ?? this.timeFormat,
      customHeaders: customHeaders ?? this.customHeaders,
    );
  }

  @override
  List<Object?> get props => [
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
        oneSignalRegistered,
        plexPass,
        dateFormat,
        timeFormat,
        customHeaders,
      ];

  factory ServerModel.fromJson(Map<String, dynamic> json) =>
      _$ServerModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServerModelToJson(this);

  static List<CustomHeaderModel> _customHeadersFromJson(
    String jsonEncodedHeaders,
  ) {
    final List decodedHeaders = jsonDecode(jsonEncodedHeaders);

    List<CustomHeaderModel> customHeaderList = [];

    for (Map<String, dynamic> header in decodedHeaders) {
      customHeaderList.add(
        CustomHeaderModel(key: header['key'], value: header['value']),
      );
    }

    return customHeaderList;
  }

  static String _customHeadersToJson(
    List<CustomHeaderModel> headers,
  ) {
    final jsonMappedHeaders = headers.map((header) => header.toJson()).toList();

    return jsonEncode(jsonMappedHeaders);
  }
}
