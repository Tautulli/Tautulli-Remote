import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/media/data/models/metadata_item_model.dart';
import 'package:tautulli_remote/features/media/domain/entities/metadata_item.dart';
import 'package:tautulli_remote/features/media/domain/repositories/metadata_repository.dart';
import 'package:tautulli_remote/features/media/domain/usecases/get_metadata.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockMetadataRepository extends Mock implements MetadataRepository {}

void main() {
  GetMetadata usecase;
  MockMetadataRepository mockMetadataRepository;

  setUp(() {
    mockMetadataRepository = MockMetadataRepository();
    usecase = GetMetadata(
      repository: mockMetadataRepository,
    );
  });

  final String tTautulliId = 'jkl';
  final int tRatingKey = 53052;

  final metadataItemJson = json.decode(fixture('metadata_item.json'));
  final MetadataItem tMetadataItem =
      MetadataItemModel.fromJson(metadataItemJson['response']['data']);

  test(
    'should get MetadataItem from repository',
    () async {
      // arrange
      when(
        mockMetadataRepository.getMetadata(
          tautulliId: anyNamed('tautulliId'),
          ratingKey: anyNamed('ratingKey'),
        ),
      ).thenAnswer((_) async => Right(tMetadataItem));
      // act
      final result = await usecase(
        tautulliId: tTautulliId,
        ratingKey: tRatingKey,
      );
      // assert
      expect(result, equals(Right(tMetadataItem)));
    },
  );
}
