// @dart=2.9

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote/features/activity/data/models/geo_ip_model.dart';
import 'package:tautulli_remote/features/activity/domain/entities/geo_ip.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tGeoIpItemModel = GeoIpItemModel(
    accuracy: null,
    city: "Toronto",
    code: "CA",
    continent: null,
    country: "Canada",
    latitude: 43.6403,
    longitude: -79.3711,
    postalCode: "M5E",
    region: "Ontario",
    timezone: "America/Toronto",
  );

  test(
    'should be a subclass of the GeoIpItem entity',
    () async {
      // assert
      expect(tGeoIpItemModel, isA<GeoIpItem>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('geo_ip_item.json'));
        // act
        final result = GeoIpItemModel.fromJson(jsonMap);
        // assert
        expect(result, tGeoIpItemModel);
      },
    );

    test(
      'should return an item with properly mapped data',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('geo_ip_item.json'));
        // act
        final result = GeoIpItemModel.fromJson(jsonMap);
        // assert
        expect(result.city, equals(jsonMap['city']));
      },
    );
  });
}
