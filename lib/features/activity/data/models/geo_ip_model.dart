import '../../../../core/helpers/value_helper.dart';
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

  factory GeoIpItemModel.fromJson(Map<String, dynamic> json) {
    return GeoIpItemModel(
      accuracy: ValueHelper.cast(
        value: json['accuracy'],
        type: CastType.int,
      ),
      city: ValueHelper.cast(
        value: json['city'],
        type: CastType.string,
      ),
      code: ValueHelper.cast(
        value: json['code'],
        type: CastType.string,
      ),
      continent: ValueHelper.cast(
        value: json['continent'],
        type: CastType.string,
      ),
      country: ValueHelper.cast(
        value: json['country'],
        type: CastType.string,
      ),
      latitude: ValueHelper.cast(
        value: json['latitude'],
        type: CastType.double,
      ),
      longitude: ValueHelper.cast(
        value: json['longitude'],
        type: CastType.double,
      ),
      postalCode: ValueHelper.cast(
        value: json['postal_code'],
        type: CastType.string,
      ),
      region: ValueHelper.cast(
        value: json['region'],
        type: CastType.string,
      ),
      timezone: ValueHelper.cast(
        value: json['timezone'],
        type: CastType.string,
      ),
    );
  }
}
