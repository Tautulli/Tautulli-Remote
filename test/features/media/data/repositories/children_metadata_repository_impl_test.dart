import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/network/network_info.dart';
import 'package:tautulli_remote/features/media/data/datasources/children_metadata_data_source.dart';
import 'package:tautulli_remote/features/media/data/models/metadata_item_model.dart';
import 'package:tautulli_remote/features/media/data/repositories/children_metadata_repository_impl.dart';
import 'package:tautulli_remote/features/media/domain/entities/metadata_item.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockChildrenMetadataDataSource extends Mock
    implements ChildrenMetadataDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  ChildrenMetadataRepositoryImpl repository;
  MockChildrenMetadataDataSource mockChildrenMetadataDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockChildrenMetadataDataSource = MockChildrenMetadataDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ChildrenMetadataRepositoryImpl(
      dataSource: mockChildrenMetadataDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final String tTautulliId = 'jkl';
  final int tRatingKey = 53052;

  final tChildrenMetadataJson = json.decode(fixture('children_metadata.json'));

  final List<MetadataItem> tChildrenMetadataList = [];
  tChildrenMetadataJson['response']['data']['children_list'].forEach((item) {
    tChildrenMetadataList.add(MetadataItemModel.fromJson(item));
  });

  group('getChildrenMetadata', () {
    test(
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getChildrenMetadata(
          tautulliId: tTautulliId,
          ratingKey: tRatingKey,
        );
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should call the data source getChildrenMetadata()',
        () async {
          // act
          await repository.getChildrenMetadata(
            tautulliId: tTautulliId,
            ratingKey: tRatingKey,
          );
          // assert
          verify(
            mockChildrenMetadataDataSource.getChildrenMetadata(
              tautulliId: tTautulliId,
              ratingKey: tRatingKey,
            ),
          );
        },
      );

      test(
        'should return list of MetadataItem when call to API is successful',
        () async {
          // arrange
          when(
            mockChildrenMetadataDataSource.getChildrenMetadata(
              tautulliId: anyNamed('tautulliId'),
              ratingKey: anyNamed('ratingKey'),
            ),
          ).thenAnswer((_) async => tChildrenMetadataList);
          // act
          final result = await repository.getChildrenMetadata(
            tautulliId: tTautulliId,
            ratingKey: tRatingKey,
          );
          // assert
          expect(result, equals(Right(tChildrenMetadataList)));
        },
      );
    });

    group('device is offline', () {
      test(
        'should return a ConnectionFailure when there is no network connection',
        () async {
          // arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
          // act
          final result = await repository.getChildrenMetadata(
            tautulliId: tTautulliId,
            ratingKey: tRatingKey,
          );
          // assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });
}
