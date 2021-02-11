import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/api/tautulli_api/tautulli_api.dart'
    as tautulliApi;
import 'package:tautulli_remote/features/libraries/data/datasources/library_media_data_source.dart';
import 'package:tautulli_remote/features/libraries/data/models/library_media_model.dart';
import 'package:tautulli_remote/features/libraries/domain/entities/library_media.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetLibraryMediaInfo extends Mock
    implements tautulliApi.GetLibraryMediaInfo {}

void main() {
  LibraryMediaDataSourceImpl dataSource;
  MockGetLibraryMediaInfo mockApiGetLibraryMediaInfo;

  setUp(() {
    mockApiGetLibraryMediaInfo = MockGetLibraryMediaInfo();
    dataSource = LibraryMediaDataSourceImpl(
      apiGetLibraryMediaInfo: mockApiGetLibraryMediaInfo,
    );
  });

  final String tTautulliId = 'jkl';
  final int tRatingKey = 53052;

  final tLibraryMediaInfoJson = json.decode(fixture('library_media_info.json'));

  final List<LibraryMedia> tLibraryMediaList = [];
  tLibraryMediaInfoJson['response']['data']['data'].forEach((item) {
    tLibraryMediaList.add(LibraryMediaModel.fromJson(item));
  });

  group('getLibraryMediaInfo', () {
    test(
      'should call [getLibraryMediaInfo] from TautulliApi',
      () async {
        // arrange
        when(
          mockApiGetLibraryMediaInfo(
            tautulliId: anyNamed('tautulliId'),
            ratingKey: anyNamed('ratingKey'),
            refresh: true,
          ),
        ).thenAnswer((_) async => tLibraryMediaInfoJson);
        // act
        await dataSource.getLibraryMediaInfo(
          tautulliId: tTautulliId,
          ratingKey: tRatingKey,
          refresh: true,
        );
        // assert
        verify(
          mockApiGetLibraryMediaInfo(
            tautulliId: tTautulliId,
            ratingKey: tRatingKey,
            refresh: true,
          ),
        );
      },
    );

    test(
      'should return a list of LibraryMedia',
      () async {
        // arrange
        when(
          mockApiGetLibraryMediaInfo(
            tautulliId: anyNamed('tautulliId'),
            ratingKey: anyNamed('ratingKey'),
            refresh: true,
          ),
        ).thenAnswer((_) async => tLibraryMediaInfoJson);
        // act
        final result = await dataSource.getLibraryMediaInfo(
          tautulliId: tTautulliId,
          ratingKey: tRatingKey,
          refresh: true,
        );
        // assert
        expect(result, equals(tLibraryMediaList));
      },
    );
  });
}
