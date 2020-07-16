import '../../domain/entities/geo_ip.dart';

class GeoIpItemModel extends GeoIpItem {
  GeoIpItemModel({
    final String code,
    final String country,
    final String region,
    final String city,
    final String postalCode,
    final String timezone,
    final double latitude,
    final double longitude,
    final String continent,
    final int accuracy,
  }) : super(
          code: code,
          country: country,
          region: region,
          city: city,
          postalCode: postalCode,
          timezone: timezone,
          latitude: latitude,
          longitude: longitude,
          continent: continent,
          accuracy: accuracy,
        );
  
  factory GeoIpItemModel.fromJson(Map<String, dynamic> json){
    return GeoIpItemModel(
      accuracy: json['accuracy'],
      city: json['city'],
      code: json['code'],
      continent: json['continent'],
      country: json['country'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      postalCode:json['postal_code'] ,
      region: json['region'],
      timezone: json['timezone'],
    );
  }
}
