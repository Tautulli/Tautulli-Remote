import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/libraries/data/models/library_model.dart';
import 'package:tautulli_remote/features/libraries/domain/entities/library.dart';
import 'package:tautulli_remote/features/libraries/domain/repositories/libraries_repository.dart';
import 'package:tautulli_remote/features/libraries/domain/usecases/get_libraries_table.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockLibrariesRepository extends Mock implements LibrariesRepository {}

void main() {
  GetLibrariesTable usecase;
  MockLibrariesRepository mockLibrariesRepository;

  setUp(() {
    mockLibrariesRepository = MockLibrariesRepository();
    usecase = GetLibrariesTable(
      repository: mockLibrariesRepository,
    );
  });

  final String tTautulliId = 'jkl';

  final List<Library> tLibrariesList = [];

  final librariesJson = json.decode(fixture('libraries.json'));

  librariesJson['response']['data']['data'].forEach((item) {
    tLibrariesList.add(LibraryModel.fromJson(item));
  });

  test(
    'should get list of Library from repository',
    () async {
      // arrange
      when(
        mockLibrariesRepository.getLibrariesTable(
          tautulliId: tTautulliId,
        ),
      ).thenAnswer((_) async => Right(tLibrariesList));
      // act
      final result = await usecase(tautulliId: tTautulliId);
      // assert
      expect(result, equals(Right(tLibrariesList)));
    },
  );
}
