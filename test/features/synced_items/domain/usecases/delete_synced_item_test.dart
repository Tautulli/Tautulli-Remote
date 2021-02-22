import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/synced_items/domain/repositories/delete_synced_item_repository.dart';
import 'package:tautulli_remote/features/synced_items/domain/usecases/delete_synced_item.dart';

class MockDeleteSyncedItemRepository extends Mock
    implements DeleteSyncedItemRepository {}

void main() {
  DeleteSyncedItem usecase;
  MockDeleteSyncedItemRepository mockDeleteSyncedItemRepository;

  setUp(() {
    mockDeleteSyncedItemRepository = MockDeleteSyncedItemRepository();
    usecase = DeleteSyncedItem(
      repository: mockDeleteSyncedItemRepository,
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
        ),
      ).thenAnswer((_) async => Right(true));
      // act
      final result = await usecase(
        tautulliId: tTautulliId,
        clientId: tClientId,
        syncId: tSyncId,
      );
      // assert
      expect(result, equals(Right(true)));
    },
  );
}
