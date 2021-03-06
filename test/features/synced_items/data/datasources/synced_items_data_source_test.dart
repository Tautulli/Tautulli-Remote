import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/api/tautulli_api/tautulli_api.dart'
    as tautulli_api;
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/synced_items/data/datasources/synced_items_data_source.dart';
import 'package:tautulli_remote/features/synced_items/data/models/synced_item_model.dart';
import 'package:tautulli_remote/features/synced_items/domain/entities/synced_item.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetSyncedItems extends Mock implements tautulli_api.GetSyncedItems {}

class MockSettings extends Mock implements Settings {}

class MockOnesignal extends Mock implements OneSignalDataSource {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockLogging extends Mock implements Logging {}

void main() {
  SyncedItemsDataSourceImpl dataSource;
  MockGetSyncedItems mockApiGetSyncedItems;
  MockSettings mockSettings;
  MockOnesignal mockOnesignal;
  MockRegisterDevice mockRegisterDevice;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockApiGetSyncedItems = MockGetSyncedItems();
    dataSource = SyncedItemsDataSourceImpl(
      apiGetSyncedItems: mockApiGetSyncedItems,
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

  final List<SyncedItem> tSyncedItemList = [];
  final syncedItemsJson = json.decode(fixture('synced_items.json'));

  syncedItemsJson['response']['data'].forEach((item) {
    tSyncedItemList.add(SyncedItemModel.fromJson(item));
  });

  group('getSyncedItems', () {
    test(
      'should call [getSyncedItems] from TautulliApi',
      () async {
        // arrange
        when(
          mockApiGetSyncedItems(
            tautulliId: anyNamed('tautulliId'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => syncedItemsJson);
        // act
        await dataSource.getSyncedItems(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(
          mockApiGetSyncedItems(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );

    test(
      'should return a list of SyncedItemModel',
      () async {
        // arrange
        when(
          mockApiGetSyncedItems(
            tautulliId: anyNamed('tautulliId'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => syncedItemsJson);
        // act
        final result = await dataSource.getSyncedItems(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        expect(result, equals(tSyncedItemList));
      },
    );
  });
}
