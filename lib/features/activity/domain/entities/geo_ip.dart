// @dart=2.9

import 'package:equatable/equatable.dart';

class GeoIpItem extends Equatable {
  final String code;
  final String country;
  final String region;
  final String city;
  final String postalCode;
  final String timezone;
  final double latitude;
  final double longitude;
  final String continent;
  final int accuracy;

  GeoIpItem({
    this.code,
    this.country,
    this.region,
    this.city,
    this.postalCode,
    this.timezone,
    this.latitude,
    this.longitude,
    this.continent,
    this.accuracy,
  });

  @override
  List<Object> get props => [
        code,
        country,
        region,
        city,
        postalCode,
        timezone,
        latitude,
        longitude,
        continent,
        accuracy,
      ];

  @override
  bool get stringify => true;
}
