// @dart=2.9

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/synced_items/domain/repositories/delete_synced_item_repository.dart';
import 'package:tautulli_remote/features/synced_items/domain/usecases/delete_synced_item.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';

class MockDeleteSyncedItemRepository extends Mock
    implements DeleteSyncedItemRepository {}

class MockSettings extends Mock implements Settings {}

class MockOnesignal extends Mock implements OneSignalDataSource {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockLogging extends Mock implements Logging {}

void main() {
  DeleteSyncedItem usecase;
  MockDeleteSyncedItemRepository mockDeleteSyncedItemRepository;
  MockSettings mockSettings;
  MockOnesignal mockOnesignal;
  MockRegisterDevice mockRegisterDevice;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockDeleteSyncedItemRepository = MockDeleteSyncedItemRepository();
    usecase = DeleteSyncedItem(
      repository: mockDeleteSyncedItemRepository,
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
  const String tClientId = 'abc';
  const int tSyncId = 123;

  test(
    'should return true when synced item is deleted successfully',
    () async {
      // arrange
      when(
        mockDeleteSyncedItemRepository(
          tautulliId: anyNamed('tautulliId'),
          clientId: anyNamed('clientId'),
          syncId: anyNamed('syncId'),
          settingsBloc: anyNamed('settingsBloc'),
        ),
      ).thenAnswer((_) async => const Right(true));
      // act
      final result = await usecase(
        tautulliId: tTautulliId,
        clientId: tClientId,
        syncId: tSyncId,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(const Right(true)));
    },
  );
}
