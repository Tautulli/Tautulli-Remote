import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/media/data/models/metadata_item_model.dart';
import 'package:tautulli_remote/features/media/domain/entities/metadata_item.dart';
import 'package:tautulli_remote/features/media/domain/repositories/children_metadata_repository.dart';
import 'package:tautulli_remote/features/media/domain/usecases/get_children_metadata.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockChildrenMetadataRepository extends Mock
    implements ChildrenMetadataRepository {}

void main() {
  GetChildrenMetadata usecase;
  MockChildrenMetadataRepository mockChildrenMetadataRepository;

  setUp(() {
    mockChildrenMetadataRepository = MockChildrenMetadataRepository();
    usecase = GetChildrenMetadata(
      repository: mockChildrenMetadataRepository,
    );
  });

  final String tTautulliId = 'jkl';
  final int tRatingKey = 53052;

  final tChildrenMetadataJson = json.decode(fixture('children_metadata.json'));

  final List<MetadataItem> tChildrenMetadataList = [];
  tChildrenMetadataJson['response']['data']['children_list'].forEach((item) {
    tChildrenMetadataList.add(MetadataItemModel.fromJson(item));
  });

  test(
    'should get list of MetadataItem from repository',
    () async {
      // arrange
      when(
        mockChildrenMetadataRepository.getChildrenMetadata(
          tautulliId: anyNamed('tautulliId'),
          ratingKey: anyNamed('ratingKey'),
        ),
      ).thenAnswer((_) async => Right(tChildrenMetadataList));
      // act
      final result = await usecase(
        tautulliId: tTautulliId,
        ratingKey: tRatingKey,
      );
      // assert
      expect(result, equals(Right(tChildrenMetadataList)));
    },
  );
}
