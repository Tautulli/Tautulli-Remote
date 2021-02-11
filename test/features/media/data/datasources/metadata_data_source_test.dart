import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/api/tautulli_api/tautulli_api.dart'
    as tautulliApi;
import 'package:tautulli_remote/features/media/data/datasources/metadata_data_source.dart';
import 'package:tautulli_remote/features/media/data/models/metadata_item_model.dart';
import 'package:tautulli_remote/features/media/domain/entities/metadata_item.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetMetadata extends Mock implements tautulliApi.GetMetadata {}

void main() {
  MetadataDataSourceImpl dataSource;
  MockGetMetadata mockApiGetMetadata;

  setUp(() {
    mockApiGetMetadata = MockGetMetadata();
    dataSource = MetadataDataSourceImpl(
      apiGetMetadata: mockApiGetMetadata,
    );
  });

  final String tTautulliId = 'jkl';
  final int tRatingKey = 53052;

  final metadataItemJson = json.decode(fixture('metadata_item.json'));
  final MetadataItem tMetadataItem =
      MetadataItemModel.fromJson(metadataItemJson['response']['data']);

  group('getMetadata', () {
    test(
      'should call [getMetadata] from TautulliApi',
      () async {
        // arrange
        when(
          mockApiGetMetadata(
            tautulliId: anyNamed('tautulliId'),
            ratingKey: anyNamed('ratingKey'),
          ),
        ).thenAnswer((_) async => metadataItemJson);
        // act
        await dataSource.getMetadata(
          tautulliId: tTautulliId,
          ratingKey: tRatingKey,
        );
        // assert
        verify(
          mockApiGetMetadata(
            tautulliId: tTautulliId,
            ratingKey: tRatingKey,
          ),
        );
      },
    );

    test(
      'should return a MetadataItem',
      () async {
        // arrange
        when(
          mockApiGetMetadata(
            tautulliId: anyNamed('tautulliId'),
            ratingKey: anyNamed('ratingKey'),
          ),
        ).thenAnswer((_) async => metadataItemJson);
        // act
        final result = await dataSource.getMetadata(
          tautulliId: tTautulliId,
          ratingKey: tRatingKey,
        );
        // assert
        expect(result, equals(tMetadataItem));
      },
    );
  });
}
