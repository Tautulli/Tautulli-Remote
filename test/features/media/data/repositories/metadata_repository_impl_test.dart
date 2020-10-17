import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/network/network_info.dart';
import 'package:tautulli_remote/features/media/data/datasources/metadata_data_source.dart';
import 'package:tautulli_remote/features/media/data/models/metadata_item_model.dart';
import 'package:tautulli_remote/features/media/data/repositories/metadata_repository_impl.dart';
import 'package:tautulli_remote/features/media/domain/entities/metadata_item.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockMetadataDataSource extends Mock implements MetadataDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MetadataRepositoryImpl repository;
  MockMetadataDataSource mockUsersDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockUsersDataSource = MockMetadataDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = MetadataRepositoryImpl(
      dataSource: mockUsersDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final String tTautulliId = 'jkl';
  final int tRatingKey = 53052;

  final metadataItemJson = json.decode(fixture('metadata_item.json'));
  final MetadataItem tMetadataItem =
      MetadataItemModel.fromJson(metadataItemJson['response']['data']);

  group('getMetadata', () {
    test(
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getMetadata(
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
        'should call the data source getMetadata()',
        () async {
          // act
          await repository.getMetadata(
            tautulliId: tTautulliId,
            ratingKey: tRatingKey,
          );
          // assert
          verify(
            mockUsersDataSource.getMetadata(
              tautulliId: tTautulliId,
              ratingKey: tRatingKey,
            ),
          );
        },
      );

      test(
        'should return MetadataItem when call to API is successful',
        () async {
          // arrange
          when(
            mockUsersDataSource.getMetadata(
              tautulliId: anyNamed('tautulliId'),
              ratingKey: anyNamed('ratingKey'),
            ),
          ).thenAnswer((_) async => tMetadataItem);
          // act
          final result = await repository.getMetadata(
            tautulliId: tTautulliId,
            ratingKey: tRatingKey,
          );
          // assert
          expect(result, equals(Right(tMetadataItem)));
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
          final result = await repository.getMetadata(
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
