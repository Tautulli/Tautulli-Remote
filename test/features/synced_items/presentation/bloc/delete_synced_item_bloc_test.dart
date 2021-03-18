import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/synced_items/domain/usecases/delete_synced_item.dart';
import 'package:tautulli_remote/features/synced_items/presentation/bloc/delete_synced_item_bloc.dart';
import 'package:tautulli_remote/core/error/failure.dart';

class MockDeleteSyncedItem extends Mock implements DeleteSyncedItem {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  MockDeleteSyncedItem mockDeleteSyncedItem;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;
  DeleteSyncedItemBloc bloc;

  setUp(() {
    mockDeleteSyncedItem = MockDeleteSyncedItem();
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );

    bloc = DeleteSyncedItemBloc(
      deleteSyncedItem: mockDeleteSyncedItem,
      logging: mockLogging,
    );
  });

  final String tTautulliId = 'jkl';
  final String tClientId = 'abc';
  final int tSyncId = 123;

  void setUpSuccess() {
    when(
      mockDeleteSyncedItem(
        tautulliId: anyNamed('tautulliId'),
        clientId: anyNamed('clientId'),
        syncId: anyNamed('syncId'),
        settingsBloc: anyNamed('settingsBloc'),
      ),
    ).thenAnswer((_) async => Right(true));
  }

  test(
    'initialState should be DeleteSyncedItemInitial',
    () async {
      // assert
      expect(bloc.state, DeleteSyncedItemInitial());
    },
  );

  group('DeleteSyncedItemStarted', () {
    test(
      'should call DeleteSyncedItem use case',
      () async {
        // arrange
        setUpSuccess();
        // act
        bloc.add(
          DeleteSyncedItemStarted(
            tautulliId: tTautulliId,
            clientId: tClientId,
            syncId: tSyncId,
            settingsBloc: settingsBloc,
          ),
        );
        await untilCalled(
          mockDeleteSyncedItem(
            tautulliId: anyNamed('tautulliId'),
            clientId: anyNamed('clientId'),
            syncId: anyNamed('syncId'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        );
        // assert
        verify(
          mockDeleteSyncedItem(
            tautulliId: tTautulliId,
            clientId: tClientId,
            syncId: tSyncId,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );

    test(
      'should emit [DeleteSyncedItemInProgress, DeleteSyncedItemSuccess] when session is terminate successfully',
      () async {
        // arrange
        setUpSuccess();
        // assert later
        final expected = [
          DeleteSyncedItemInProgress(syncId: tSyncId),
          DeleteSyncedItemSuccess(),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(
          DeleteSyncedItemStarted(
            tautulliId: tTautulliId,
            clientId: tClientId,
            syncId: tSyncId,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );

    test(
      'should emit [DeleteSyncedItemInProgress, DeleteSyncedItemFailure] when session fails to terminate',
      () async {
        // arrange
        when(
          mockDeleteSyncedItem(
            tautulliId: anyNamed('tautulliId'),
            clientId: anyNamed('clientId'),
            syncId: anyNamed('syncId'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => Left(DeleteSyncedFailure()));
        // assert later
        final expected = [
          DeleteSyncedItemInProgress(syncId: tSyncId),
          DeleteSyncedItemFailure(failure: DeleteSyncedFailure()),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(
          DeleteSyncedItemStarted(
            tautulliId: tTautulliId,
            clientId: tClientId,
            syncId: tSyncId,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );
  });
}
