import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/network/network_info.dart';
import 'package:tautulli_remote/features/libraries/data/datasources/library_media_data_source.dart';
import 'package:tautulli_remote/features/libraries/data/models/library_media_model.dart';
import 'package:tautulli_remote/features/libraries/data/repositories/library_media_repository_impl.dart';
import 'package:tautulli_remote/features/libraries/domain/entities/library_media.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockLibraryMediaDataSource extends Mock
    implements LibraryMediaDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  LibraryMediaRepositoryImpl repository;
  MockLibraryMediaDataSource mockLibraryMediaDataSource;
  MockNetworkInfo mockNetworkInfo;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockLibraryMediaDataSource = MockLibraryMediaDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = LibraryMediaRepositoryImpl(
      dataSource: mockLibraryMediaDataSource,
      networkInfo: mockNetworkInfo,
    );
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
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
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getLibraryMediaInfo(
          tautulliId: tTautulliId,
          ratingKey: tRatingKey,
          refresh: true,
          settingsBloc: settingsBloc,
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
        'should call the data source getLibraryMediaInfo()',
        () async {
          // act
          await repository.getLibraryMediaInfo(
            tautulliId: tTautulliId,
            ratingKey: tRatingKey,
            refresh: true,
            settingsBloc: settingsBloc,
          );
          // assert
          verify(
            mockLibraryMediaDataSource.getLibraryMediaInfo(
              tautulliId: tTautulliId,
              ratingKey: tRatingKey,
              refresh: true,
              settingsBloc: settingsBloc,
            ),
          );
        },
      );

      test(
        'should return list of LibraryMedia when call to API is successful',
        () async {
          // arrange
          when(
            mockLibraryMediaDataSource.getLibraryMediaInfo(
              tautulliId: anyNamed('tautulliId'),
              ratingKey: anyNamed('ratingKey'),
              refresh: true,
              settingsBloc: anyNamed('settingsBloc'),
            ),
          ).thenAnswer((_) async => tLibraryMediaList);
          // act
          final result = await repository.getLibraryMediaInfo(
            tautulliId: tTautulliId,
            ratingKey: tRatingKey,
            refresh: true,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Right(tLibraryMediaList)));
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
          final result = await repository.getLibraryMediaInfo(
            tautulliId: tTautulliId,
            ratingKey: tRatingKey,
            refresh: true,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });
}
