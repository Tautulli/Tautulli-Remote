// @dart=2.9

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/network/network_info.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/media/data/datasources/children_metadata_data_source.dart';
import 'package:tautulli_remote/features/media/data/models/metadata_item_model.dart';
import 'package:tautulli_remote/features/media/data/repositories/children_metadata_repository_impl.dart';
import 'package:tautulli_remote/features/media/domain/entities/metadata_item.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockChildrenMetadataDataSource extends Mock
    implements ChildrenMetadataDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockSettings extends Mock implements Settings {}

class MockOnesignal extends Mock implements OneSignalDataSource {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockLogging extends Mock implements Logging {}

void main() {
  ChildrenMetadataRepositoryImpl repository;
  MockChildrenMetadataDataSource mockChildrenMetadataDataSource;
  MockNetworkInfo mockNetworkInfo;
  MockSettings mockSettings;
  MockOnesignal mockOnesignal;
  MockRegisterDevice mockRegisterDevice;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockChildrenMetadataDataSource = MockChildrenMetadataDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ChildrenMetadataRepositoryImpl(
      dataSource: mockChildrenMetadataDataSource,
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
  const int tRatingKey = 53052;

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
        await repository.getChildrenMetadata(
          tautulliId: tTautulliId,
          ratingKey: tRatingKey,
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
        'should call the data source getChildrenMetadata()',
        () async {
          // act
          await repository.getChildrenMetadata(
            tautulliId: tTautulliId,
            ratingKey: tRatingKey,
            settingsBloc: settingsBloc,
          );
          // assert
          verify(
            mockChildrenMetadataDataSource.getChildrenMetadata(
              tautulliId: tTautulliId,
              ratingKey: tRatingKey,
              settingsBloc: settingsBloc,
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
              settingsBloc: anyNamed('settingsBloc'),
            ),
          ).thenAnswer((_) async => tChildrenMetadataList);
          // act
          final result = await repository.getChildrenMetadata(
            tautulliId: tTautulliId,
            ratingKey: tRatingKey,
            settingsBloc: settingsBloc,
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
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });
}
