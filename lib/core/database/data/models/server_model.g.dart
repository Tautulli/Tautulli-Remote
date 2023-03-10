// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerModel _$ServerModelFromJson(Map<String, dynamic> json) => ServerModel(
      id: json['id'] as int?,
      sortIndex: json['sort_index'] as int,
      plexName: json['plex_name'] as String,
      plexIdentifier: json['plex_identifier'] as String,
      tautulliId: json['tautulli_id'] as String,
      primaryConnectionAddress: json['primary_connection_address'] as String,
      primaryConnectionProtocol: json['primary_connection_protocol'] as String,
      primaryConnectionDomain: json['primary_connection_domain'] as String,
      primaryConnectionPath: json['primary_connection_path'] as String?,
      secondaryConnectionAddress:
          json['secondary_connection_address'] as String?,
      secondaryConnectionProtocol:
          json['secondary_connection_protocol'] as String?,
      secondaryConnectionDomain: json['secondary_connection_domain'] as String?,
      secondaryConnectionPath: json['secondary_connection_path'] as String?,
      deviceToken: json['device_token'] as String,
      primaryActive: Cast.castToBool(json['primary_active']),
      oneSignalRegistered: Cast.castToBool(json['onesignal_registered']),
      plexPass: Cast.castToBool(json['plex_pass']),
      dateFormat: json['date_format'] as String?,
      timeFormat: json['time_format'] as String?,
      customHeaders:
          ServerModel._customHeadersFromJson(json['custom_headers'] as String),
    );

Map<String, dynamic> _$ServerModelToJson(ServerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sort_index': instance.sortIndex,
      'plex_name': instance.plexName,
      'plex_identifier': instance.plexIdentifier,
      'tautulli_id': instance.tautulliId,
      'primary_connection_address': instance.primaryConnectionAddress,
      'primary_connection_protocol': instance.primaryConnectionProtocol,
      'primary_connection_domain': instance.primaryConnectionDomain,
      'primary_connection_path': instance.primaryConnectionPath,
      'secondary_connection_address': instance.secondaryConnectionAddress,
      'secondary_connection_protocol': instance.secondaryConnectionProtocol,
      'secondary_connection_domain': instance.secondaryConnectionDomain,
      'secondary_connection_path': instance.secondaryConnectionPath,
      'device_token': instance.deviceToken,
      'primary_active': Cast.castToInt(instance.primaryActive),
      'onesignal_registered': Cast.castToInt(instance.oneSignalRegistered),
      'plex_pass': Cast.castToInt(instance.plexPass),
      'date_format': instance.dateFormat,
      'time_format': instance.timeFormat,
      'custom_headers':
          ServerModel._customHeadersToJson(instance.customHeaders),
    };
