import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote/features/graphs/data/models/graph_data_model.dart';
import 'package:tautulli_remote/features/graphs/data/models/series_data_model.dart';
import 'package:tautulli_remote/features/graphs/domain/entities/graph_data.dart';
import 'package:tautulli_remote/features/graphs/domain/entities/series_data.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tGraphDataModel = GraphDataModel(
    graphType: GraphType.playsByDate,
    categories: const [
      '2021-03-07',
      '2021-03-08',
      '2021-03-09',
      '2021-03-10',
      '2021-03-11',
      '2021-03-12',
      '2021-03-13',
      '2021-03-14',
      '2021-03-15',
      '2021-03-16',
      '2021-03-17',
      '2021-03-18',
      '2021-03-19',
      '2021-03-20',
      '2021-03-21',
      '2021-03-22',
      '2021-03-23',
      '2021-03-24',
      '2021-03-25',
      '2021-03-26',
      '2021-03-27',
      '2021-03-28',
      '2021-03-29',
      '2021-03-30',
      '2021-03-31',
      '2021-04-01',
      '2021-04-02',
      '2021-04-03',
      '2021-04-04',
      '2021-04-05',
    ],
    seriesDataList: [
      SeriesDataModel(
        seriesType: SeriesType.tv,
        seriesData: const [
          7,
          3,
          2,
          4,
          2,
          3,
          1,
          14,
          10,
          16,
          0,
          1,
          5,
          10,
          3,
          7,
          8,
          3,
          1,
          22,
          19,
          19,
          10,
          16,
          10,
          10,
          12,
          6,
          11,
          0
        ],
      ),
      SeriesDataModel(
        seriesType: SeriesType.movies,
        seriesData: const [
          2,
          2,
          1,
          0,
          2,
          0,
          3,
          4,
          0,
          0,
          0,
          1,
          0,
          5,
          2,
          0,
          1,
          1,
          0,
          0,
          1,
          1,
          1,
          1,
          0,
          0,
          1,
          2,
          4,
          0,
        ],
      ),
      SeriesDataModel(
        seriesType: SeriesType.music,
        seriesData: const [
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
        ],
      ),
    ],
  );
  final tSeriesDataModel = SeriesDataModel(
    seriesType: SeriesType.tv,
    seriesData: const [
      7,
      3,
      2,
      4,
      2,
      3,
      1,
      14,
      10,
      16,
      0,
      1,
      5,
      10,
      3,
      7,
      8,
      3,
      1,
      22,
      19,
      19,
      10,
      16,
      10,
      10,
      12,
      6,
      11,
      0,
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
            json.decode(fixture('graphs_play_by_date_series_item.json'));
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
            json.decode(fixture('graphs_play_by_date_series_item.json'));
        // act
        final result = SeriesDataModel.fromJson(jsonMap);
        // assert
        expect(result.seriesData, jsonMap['data']);
      },
    );
  });
}
