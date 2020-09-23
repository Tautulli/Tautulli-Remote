import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/core/api/tautulli_api.dart';
import 'package:tautulli_remote_tdd/features/libraries/data/datasources/libraries_data_source.dart';
import 'package:tautulli_remote_tdd/features/libraries/data/models/library_model.dart';
import 'package:tautulli_remote_tdd/features/libraries/domain/entities/library.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockTautulliApi extends Mock implements TautulliApi {}

void main() {
  LibrariesDataSourceImpl dataSource;
  MockTautulliApi mockTautulliApi;

  setUp(() {
    mockTautulliApi = MockTautulliApi();
    dataSource = LibrariesDataSourceImpl(tautulliApi: mockTautulliApi);
  });

  final String tTautulliId = 'jkl';

  final List<Library> tLibrariesList = [];

  final librariesJson = json.decode(fixture('libraries.json'));

  librariesJson['response']['data']['data'].forEach((item) {
    tLibrariesList.add(LibraryModel.fromJson(item));
  });

  group('getLibrariesTable', () {
    test(
      'should call [getLibrariesTable] from TautilliApi',
      () async {
        // arrange
        when(
          mockTautulliApi.getLibrariesTable(
            tautulliId: anyNamed('tautulliId'),
          ),
        ).thenAnswer((_) async => librariesJson);
        // act
        await dataSource.getLibrariesTable(tautulliId: tTautulliId);
        // assert
        verify(mockTautulliApi.getLibrariesTable(tautulliId: tTautulliId));
      },
    );

    test(
      'should return list of LibraryModel',
      () async {
        // arrange
        when(
          mockTautulliApi.getLibrariesTable(
            tautulliId: anyNamed('tautulliId'),
          ),
        ).thenAnswer((_) async => librariesJson);
        // act
        final result = await dataSource.getLibrariesTable(tautulliId: tTautulliId);
        // assert
        expect(result, equals(tLibrariesList));
      },
    );
  });
}
