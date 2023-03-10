// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_ip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeoIpModel _$GeoIpModelFromJson(Map<String, dynamic> json) => GeoIpModel(
      code: Cast.castToString(json['code']),
      country: Cast.castToString(json['country']),
      region: Cast.castToString(json['region']),
      city: Cast.castToString(json['city']),
      postalCode: Cast.castToString(json['postal_code']),
      timezone: Cast.castToString(json['timezone']),
      latitude: Cast.castToNum(json['latitude']),
      longitude: Cast.castToNum(json['longitude']),
      continent: Cast.castToNum(json['continent']),
    );

Map<String, dynamic> _$GeoIpModelToJson(GeoIpModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'country': instance.country,
      'region': instance.region,
      'city': instance.city,
      'postal_code': instance.postalCode,
      'timezone': instance.timezone,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'continent': instance.continent,
    };
