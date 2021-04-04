import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/api/tautulli_api/tautulli_api.dart'
    as tautulli_api;
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/synced_items/data/datasources/delete_synced_item_data_source.dart';

class MockDeleteSyncedItem extends Mock
    implements tautulli_api.DeleteSyncedItem {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  DeleteSyncedItemDataSourceImpl dataSource;
  MockDeleteSyncedItem mockApiDeleteSyncedItem;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockApiDeleteSyncedItem = MockDeleteSyncedItem();
    dataSource = DeleteSyncedItemDataSourceImpl(
      apiDeleteSyncedItem: mockApiDeleteSyncedItem,
    );
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
  });

  const String tTautulliId = 'jkl';
  const String tClientId = 'abc';
  const int tSyncId = 123;

  final Map<String, dynamic> successMap = {
    'response': {
      'result': 'success',
    }
  };

  final Map<String, dynamic> failureMap = {
    'response': {
      'result': 'error',
    }
  };

  test(
    'should call [deleteSyncedItem] from TautulliApi',
    () async {
      // arrange
      when(
        mockApiDeleteSyncedItem(
          tautulliId: anyNamed('tautulliId'),
          clientId: anyNamed('clientId'),
          syncId: anyNamed('syncId'),
          settingsBloc: anyNamed('settingsBloc'),
        ),
      ).thenAnswer((_) async => successMap);
      // act
      await dataSource(
        tautulliId: tTautulliId,
        clientId: tClientId,
        syncId: tSyncId,
        settingsBloc: settingsBloc,
      );
      // assert
      verify(
        mockApiDeleteSyncedItem(
          tautulliId: tTautulliId,
          clientId: tClientId,
          syncId: tSyncId,
          settingsBloc: settingsBloc,
        ),
      );
    },
  );

  test(
    'should return true is deletion is successful',
    () async {
      // arrange
      when(
        mockApiDeleteSyncedItem(
          tautulliId: anyNamed('tautulliId'),
          clientId: anyNamed('clientId'),
          syncId: anyNamed('syncId'),
          settingsBloc: anyNamed('settingsBloc'),
        ),
      ).thenAnswer((_) async => successMap);
      // act
      final result = await dataSource(
        tautulliId: tTautulliId,
        clientId: tClientId,
        syncId: tSyncId,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(true));
    },
  );

  test(
    'should return false is deletion fails',
    () async {
      // arrange
      when(
        mockApiDeleteSyncedItem(
          tautulliId: anyNamed('tautulliId'),
          clientId: anyNamed('clientId'),
          syncId: anyNamed('syncId'),
          settingsBloc: anyNamed('settingsBloc'),
        ),
      ).thenAnswer((_) async => failureMap);
      // act
      final result = await dataSource(
        tautulliId: tTautulliId,
        clientId: tClientId,
        syncId: tSyncId,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(false));
    },
  );
}
