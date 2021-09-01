// @dart=2.9

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/network/network_info.dart';
import 'package:tautulli_remote/features/libraries/data/datasources/libraries_data_source.dart';
import 'package:tautulli_remote/features/libraries/data/models/library_model.dart';
import 'package:tautulli_remote/features/libraries/data/repositories/libraries_repository_impl.dart';
import 'package:tautulli_remote/features/libraries/domain/entities/library.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockLibrariesDataSource extends Mock implements LibrariesDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockSettings extends Mock implements Settings {}

class MockOnesignal extends Mock implements OneSignalDataSource {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockLogging extends Mock implements Logging {}

void main() {
  LibrariesRepositoryImpl repository;
  MockLibrariesDataSource mockLibrariesDataSource;
  MockNetworkInfo mockNetworkInfo;
  MockSettings mockSettings;
  MockOnesignal mockOnesignal;
  MockRegisterDevice mockRegisterDevice;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockLibrariesDataSource = MockLibrariesDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = LibrariesRepositoryImpl(
      dataSource: mockLibrariesDataSource,
      networkInfo: mockNetworkInfo,
    );
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    mockOnesignal = MockOnesignal();
    mockRegisterDevice = MockRegisterDevice();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      onesignal: mockOnesignal,
      registerDevice: mockRegisterDevice,
      logging: mockLogging,
    );
  });

  const String tTautulliId = 'jkl';

  final List<Library> tLibrariesList = [];

  final librariesJson = json.decode(fixture('libraries.json'));

  librariesJson['response']['data']['data'].forEach((item) {
    tLibrariesList.add(LibraryModel.fromJson(item));
  });

  test(
    'should check if device is online',
    () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repository.getLibrariesTable(
        tautulliId: tTautulliId,
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
      'should call the data source getLibrariesTable()',
      () async {
        // act
        await repository.getLibrariesTable(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(
          mockLibrariesDataSource.getLibrariesTable(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );

    test(
      'should return list of Library when call to API is successful',
      () async {
        // arrange
        when(
          mockLibrariesDataSource.getLibrariesTable(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          ),
        ).thenAnswer((_) async => tLibrariesList);
        // act
        final result = await repository.getLibrariesTable(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        expect(result, equals(Right(tLibrariesList)));
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
        final result = await repository.getLibrariesTable(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        expect(result, equals(Left(ConnectionFailure())));
      },
    );
  });
}
