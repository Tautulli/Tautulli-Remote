import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/libraries/data/models/library_media_model.dart';
import 'package:tautulli_remote/features/libraries/domain/entities/library_media.dart';
import 'package:tautulli_remote/features/libraries/domain/repositories/library_media_repository.dart';
import 'package:tautulli_remote/features/libraries/domain/usecases/get_library_media_info.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockLibraryMediaRepository extends Mock
    implements LibraryMediaRepository {}

void main() {
  GetLibraryMediaInfo usecase;
  MockLibraryMediaRepository mockLibraryMediaRepository;

  setUp(() {
    mockLibraryMediaRepository = MockLibraryMediaRepository();
    usecase = GetLibraryMediaInfo(
      repository: mockLibraryMediaRepository,
    );
  });

  final String tTautulliId = 'jkl';
  final int tRatingKey = 53052;

  final tLibraryMediaInfoJson = json.decode(fixture('library_media_info.json'));

  final List<LibraryMedia> tLibraryMediaList = [];
  tLibraryMediaInfoJson['response']['data']['data'].forEach((item) {
    tLibraryMediaList.add(LibraryMediaModel.fromJson(item));
  });

  test(
    'should get list of LibraryMedia from repository',
    () async {
      // arrange
      when(
        mockLibraryMediaRepository.getLibraryMediaInfo(
          tautulliId: anyNamed('tautulliId'),
          ratingKey: anyNamed('ratingKey'),
          orderDir: anyNamed('orderDir'),
          start: anyNamed('start'),
          length: anyNamed('length'),
          refresh: anyNamed('refresh'),
        ),
      ).thenAnswer((_) async => Right(tLibraryMediaList));
      // act
      final result = await usecase(
        tautulliId: tTautulliId,
        ratingKey: tRatingKey,
      );
      // assert
      expect(result, equals(Right(tLibraryMediaList)));
    },
  );
}
