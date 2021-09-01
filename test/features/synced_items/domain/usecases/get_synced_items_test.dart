// @dart=2.9

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/synced_items/data/models/synced_item_model.dart';
import 'package:tautulli_remote/features/synced_items/domain/entities/synced_item.dart';
import 'package:tautulli_remote/features/synced_items/domain/repositories/synced_items_repository.dart';
import 'package:tautulli_remote/features/synced_items/domain/usecases/get_synced_items.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSyncedItemsRepository extends Mock implements SyncedItemsRepository {}

class MockSettings extends Mock implements Settings {}

class MockOnesignal extends Mock implements OneSignalDataSource {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockLogging extends Mock implements Logging {}

void main() {
  GetSyncedItems usecase;
  MockSyncedItemsRepository mockSyncedItemsRepository;
  MockSettings mockSettings;
  MockOnesignal mockOnesignal;
  MockRegisterDevice mockRegisterDevice;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockSyncedItemsRepository = MockSyncedItemsRepository();
    usecase = GetSyncedItems(
      repository: mockSyncedItemsRepository,
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

  const tTautulliId = 'jkl';
  final List<SyncedItem> tSyncedItemsList = [];

  final syncedItemsJson = json.decode(fixture('synced_items.json'));

  syncedItemsJson['response']['data'].forEach((item) {
    tSyncedItemsList.add(SyncedItemModel.fromJson(item));
  });

  test(
    'should get list of SyncedItem from repository',
    () async {
      // arrange
      when(
        mockSyncedItemsRepository.getSyncedItems(
          tautulliId: anyNamed('tautulliId'),
          settingsBloc: anyNamed('settingsBloc'),
        ),
      ).thenAnswer((_) async => Right(tSyncedItemsList));
      // act
      final result = await usecase(
        tautulliId: tTautulliId,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(Right(tSyncedItemsList)));
    },
  );
}
