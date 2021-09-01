// @dart=2.9

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote/features/graphs/data/models/series_data_model.dart';
import 'package:tautulli_remote/features/graphs/domain/entities/series_data.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tSeriesDataModel = SeriesDataModel(
    seriesType: SeriesType.tv,
    seriesData: const [
      12,
      8,
      10,
      2,
      10,
      8,
      9,
      11,
      4,
      7,
      1,
      6,
      7,
      1,
    ],
  );

  test('should be a subclass of SeriesData entity', () async {
    //assert
    expect(tSeriesDataModel, isA<SeriesData>());
  });

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('graphs_series_item.json'));
        // act
        final result = SeriesDataModel.fromJson(jsonMap);
        // assert
        expect(result, tSeriesDataModel);
      },
    );

    test(
      'should return an item with properly mapped data',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('graphs_series_item.json'));
        // act
        final result = SeriesDataModel.fromJson(jsonMap);
        // assert
        expect(result.seriesData, jsonMap['data']);
      },
    );
  });
}
