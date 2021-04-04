import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/network/network_info.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/recent/data/datasources/recently_added_data_source.dart';
import 'package:tautulli_remote/features/recent/data/models/recent_model.dart';
import 'package:tautulli_remote/features/recent/data/repositories/recently_added_repository_impl.dart';
import 'package:tautulli_remote/features/recent/domain/entities/recent.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockRecentlyAddedDataSource extends Mock
    implements RecentlyAddedDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  RecentlyAddedRepositoryImpl repository;
  MockRecentlyAddedDataSource mockRecentlyAddedDataSource;
  MockNetworkInfo mockNetworkInfo;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockRecentlyAddedDataSource = MockRecentlyAddedDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = RecentlyAddedRepositoryImpl(
      dataSource: mockRecentlyAddedDataSource,
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
  final int tCount = 10;

  final List<RecentItem> tRecentList = [];

  final recentJson = json.decode(fixture('recent.json'));

  recentJson['response']['data']['recently_added'].forEach((item) {
    tRecentList.add(RecentItemModel.fromJson(item));
  });

  test(
    'should check if device is online',
    () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repository.getRecentlyAdded(
        tautulliId: tTautulliId,
        count: tCount,
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
      'should call the data source getRecentlyAdded()',
      () async {
        // act
        await repository.getRecentlyAdded(
          tautulliId: tTautulliId,
          count: tCount,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(
          mockRecentlyAddedDataSource.getRecentlyAdded(
            tautulliId: tTautulliId,
            count: tCount,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );

    test(
      'should return list of RecentItem when call to API is successful',
      () async {
        // arrange
        when(
          mockRecentlyAddedDataSource.getRecentlyAdded(
            tautulliId: anyNamed('tautulliId'),
            count: anyNamed('count'),
            start: anyNamed('start'),
            mediaType: anyNamed('mediaType'),
            sectionId: anyNamed('sectionId'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => tRecentList);
        // act
        final result = await repository.getRecentlyAdded(
          tautulliId: tTautulliId,
          count: tCount,
          settingsBloc: settingsBloc,
        );
        // assert
        expect(result, equals(Right(tRecentList)));
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
        final result = await repository.getRecentlyAdded(
          tautulliId: tTautulliId,
          count: tCount,
          settingsBloc: settingsBloc,
        );
        // assert
        expect(result, equals(Left(ConnectionFailure())));
      },
    );
  });
}
