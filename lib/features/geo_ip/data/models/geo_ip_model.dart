import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utilities/cast.dart';

part 'geo_ip_model.g.dart';

@JsonSerializable()
class GeoIpModel extends Equatable {
  @JsonKey(name: 'code', fromJson: Cast.castToString)
  final String? code;
  @JsonKey(name: 'country', fromJson: Cast.castToString)
  final String? country;
  @JsonKey(name: 'region', fromJson: Cast.castToString)
  final String? region;
  @JsonKey(name: 'city', fromJson: Cast.castToString)
  final String? city;
  @JsonKey(name: 'postal_code', fromJson: Cast.castToString)
  final String? postalCode;
  @JsonKey(name: 'timezone', fromJson: Cast.castToString)
  final String? timezone;
  @JsonKey(name: 'latitude', fromJson: Cast.castToNum)
  final num? latitude;
  @JsonKey(name: 'longitude', fromJson: Cast.castToNum)
  final num? longitude;
  @JsonKey(name: 'continent', fromJson: Cast.castToNum)
  final num? continent;

  const GeoIpModel({
    this.code,
    this.country,
    this.region,
    this.city,
    this.postalCode,
    this.timezone,
    this.latitude,
    this.longitude,
    this.continent,
  });

  factory GeoIpModel.fromJson(Map<String, dynamic> json) =>
      _$GeoIpModelFromJson(json);

  Map<String, dynamic> toJson() => _$GeoIpModelToJson(this);

  @override
  List<Object?> get props => [
        code,
        country,
        city,
        postalCode,
        timezone,
        latitude,
        longitude,
        continent,
      ];
}
