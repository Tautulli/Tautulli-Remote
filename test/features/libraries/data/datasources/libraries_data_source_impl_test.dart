import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/api/tautulli_api/tautulli_api.dart'
    as tautulliApi;
import 'package:tautulli_remote/features/libraries/data/datasources/libraries_data_source.dart';
import 'package:tautulli_remote/features/libraries/data/models/library_model.dart';
import 'package:tautulli_remote/features/libraries/domain/entities/library.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetLibrariesTable extends Mock
    implements tautulliApi.GetLibrariesTable {}

void main() {
  LibrariesDataSourceImpl dataSource;
  MockGetLibrariesTable mockApiGetLibrariesTable;

  setUp(() {
    mockApiGetLibrariesTable = MockGetLibrariesTable();
    dataSource =
        LibrariesDataSourceImpl(apiGetLibrariesTable: mockApiGetLibrariesTable);
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
          mockApiGetLibrariesTable(
            tautulliId: anyNamed('tautulliId'),
          ),
        ).thenAnswer((_) async => librariesJson);
        // act
        await dataSource.getLibrariesTable(tautulliId: tTautulliId);
        // assert
        verify(mockApiGetLibrariesTable(tautulliId: tTautulliId));
      },
    );

    test(
      'should return list of LibraryModel',
      () async {
        // arrange
        when(
          mockApiGetLibrariesTable(
            tautulliId: anyNamed('tautulliId'),
          ),
        ).thenAnswer((_) async => librariesJson);
        // act
        final result =
            await dataSource.getLibrariesTable(tautulliId: tTautulliId);
        // assert
        expect(result, equals(tLibrariesList));
      },
    );
  });
}
