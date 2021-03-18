import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/synced_items/domain/repositories/delete_synced_item_repository.dart';
import 'package:tautulli_remote/features/synced_items/domain/usecases/delete_synced_item.dart';

class MockDeleteSyncedItemRepository extends Mock
    implements DeleteSyncedItemRepository {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  DeleteSyncedItem usecase;
  MockDeleteSyncedItemRepository mockDeleteSyncedItemRepository;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockDeleteSyncedItemRepository = MockDeleteSyncedItemRepository();
    usecase = DeleteSyncedItem(
      repository: mockDeleteSyncedItemRepository,
    );
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
  });

  final String tTautulliId = 'jkl';
  final String tClientId = 'abc';
  final int tSyncId = 123;

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
      ).thenAnswer((_) async => Right(true));
      // act
      final result = await usecase(
        tautulliId: tTautulliId,
        clientId: tClientId,
        syncId: tSyncId,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(Right(true)));
    },
  );
}
