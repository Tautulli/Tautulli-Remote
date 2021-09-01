// @dart=2.9

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote/core/error/exception.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/network/network_info.dart';
import 'package:tautulli_remote/features/activity/data/datasources/activity_data_source.dart';
import 'package:tautulli_remote/features/activity/data/models/activity_model.dart';
import 'package:tautulli_remote/features/activity/data/repositories/activity_repository_impl.dart';
import 'package:matcher/matcher.dart';
import 'package:tautulli_remote/features/activity/domain/entities/activity.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockActivityDataSource extends Mock implements ActivityDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockSettings extends Mock implements Settings {}

class MockOnesignal extends Mock implements OneSignalDataSource {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockLogging extends Mock implements Logging {}

void main() {
  ActivityRepositoryImpl repository;
  MockActivityDataSource dataSource;
  MockNetworkInfo mockNetworkInfo;
  MockSettings mockSettings;
  MockOnesignal mockOnesignal;
  MockRegisterDevice mockRegisterDevice;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    dataSource = MockActivityDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ActivityRepositoryImpl(
      dataSource: dataSource,
      networkInfo: mockNetworkInfo,
    );
    mockSettings = MockSettings();
    mockOnesignal = MockOnesignal();
    mockRegisterDevice = MockRegisterDevice();
    mockLogging = MockLogging();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      onesignal: mockOnesignal,
      registerDevice: mockRegisterDevice,
      logging: mockLogging,
    );
  });

  const tTautulliId = 'abc';

  final tActivityJson = json.decode(fixture('activity.json'));

  List<ActivityItem> tActivityList = [];
  tActivityJson['response']['data']['sessions'].forEach(
    (session) {
      tActivityList.add(
        ActivityItemModel.fromJson(session),
      );
    },
  );

  group('getActivity', () {
    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        //act
        await repository.getActivity(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        //assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should call data source getActivity()',
        () async {
          // act
          await repository.getActivity(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          verify(dataSource.getActivity(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          ));
        },
      );

      test(
        'should return activity data map when the call to api is successful',
        () async {
          // arrange
          when(
            dataSource.getActivity(
              tautulliId: tTautulliId,
              settingsBloc: settingsBloc,
            ),
          ).thenAnswer((_) async => tActivityList);
          //act
          final result = await repository.getActivity(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          //assert
          expect(result, equals(Right(tActivityList)));
        },
      );

      test(
        'should return activity',
        () async {
          // arrange
          when(dataSource.getActivity(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          )).thenAnswer((_) async => tActivityList);
          // act
          final result = await repository.getActivity(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Right(tActivityList)));
        },
      );

      test(
        'should return proper Failure using FailureMapperHelper if a known exception is thrown',
        () async {
          // arrange
          final exception = SettingsException();
          when(dataSource.getActivity(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          )).thenThrow(exception);
          // act
          final result = await repository.getActivity(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Left(SettingsFailure())));
        },
      );
    });

    group('device is offline', () {
      test(
        'should return a ConnectionFailure when there is no internet',
        () async {
          // arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
          //act
          final result = await repository.getActivity(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          //assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });
}
