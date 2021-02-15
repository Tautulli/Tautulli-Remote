import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/helpers/failure_mapper_helper.dart';
import 'package:tautulli_remote/features/image_url/domain/usecases/get_image_url.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/media/data/models/metadata_item_model.dart';
import 'package:tautulli_remote/features/media/domain/entities/metadata_item.dart';
import 'package:tautulli_remote/features/media/domain/usecases/get_metadata.dart';
import 'package:tautulli_remote/features/synced_items/data/models/synced_item_model.dart';
import 'package:tautulli_remote/features/synced_items/domain/entities/synced_item.dart';
import 'package:tautulli_remote/features/synced_items/domain/usecases/get_synced_items.dart';
import 'package:tautulli_remote/features/synced_items/presentation/bloc/synced_items_bloc.dart';

import '../../../fixtures/fixture_reader.dart';

class MockGetSyncedItems extends Mock implements GetSyncedItems {}

class MockGetMetadata extends Mock implements GetMetadata {}

class MockGetImageUrl extends Mock implements GetImageUrl {}

class MockLogging extends Mock implements Logging {}

void main() {
  SyncedItemsBloc bloc;
  MockGetSyncedItems mockGetSyncedItems;
  MockGetMetadata mockGetMetadata;
  MockGetImageUrl mockGetImageUrl;
  MockLogging mockLogging;

  setUp(() {
    mockGetSyncedItems = MockGetSyncedItems();
    mockGetMetadata = MockGetMetadata();
    mockGetImageUrl = MockGetImageUrl();
    mockLogging = MockLogging();

    bloc = SyncedItemsBloc(
      getSyncedItems: mockGetSyncedItems,
      getMetadata: mockGetMetadata,
      getImageUrl: mockGetImageUrl,
      logging: mockLogging,
    );
  });

  final tTautulliId = 'jkl';

  final List<SyncedItem> tSyncedItemsList = [];
  final syncedItemsJson = json.decode(fixture('synced_items.json'));
  syncedItemsJson['response']['data'].forEach((item) {
    tSyncedItemsList.add(SyncedItemModel.fromJson(item));
  });

  final metadataItemJson = json.decode(fixture('metadata_item.json'));
  final MetadataItem tMetadataItem =
      MetadataItemModel.fromJson(metadataItemJson['response']['data']);

  void setUpSuccess() {
    String imageUrl =
        'https://tautulli.domain.com/api/v2?img=/library/metadata/98329/thumb/1591948561&rating_key=98329&width=null&height=300&opacity=null&background=null&blur=null&fallback=poster&cmd=pms_image_proxy&apikey=3c9&app=true';
    when(
      mockGetImageUrl(
        tautulliId: anyNamed('tautulliId'),
        img: anyNamed('img'),
        ratingKey: anyNamed('ratingKey'),
        fallback: anyNamed('fallback'),
      ),
    ).thenAnswer((_) async => Right(imageUrl));
    when(mockGetSyncedItems(
      tautulliId: anyNamed('tautulliId'),
    )).thenAnswer((_) async => Right(tSyncedItemsList));
    when(mockGetMetadata(
      tautulliId: anyNamed('tautulliId'),
      ratingKey: anyNamed('ratingKey'),
      syncId: anyNamed('syncId'),
    )).thenAnswer((_) async => Right(tMetadataItem));
  }

  test(
    'initialState should be SyncedItemsInitial',
    () async {
      // assert
      expect(bloc.state, SyncedItemsInitial());
    },
  );

  group('SyncedItemsFetch', () {
    test(
      'should get data from GetSyncedItems use case',
      () async {
        // arrange
        setUpSuccess();
        clearCache();
        // act
        bloc.add(SyncedItemsFetch(tautulliId: tTautulliId));
        await untilCalled(mockGetSyncedItems(
          tautulliId: anyNamed('tautulliId'),
        ));
        // assert
        verify(
          mockGetSyncedItems(
            tautulliId: tTautulliId,
          ),
        );
      },
    );

    test(
      'should get data from the ImageUrl use case',
      () async {
        // arrange
        setUpSuccess();
        clearCache();
        // act
        bloc.add(
          SyncedItemsFetch(
            tautulliId: tTautulliId,
          ),
        );
        await untilCalled(
          mockGetImageUrl(
            tautulliId: anyNamed('tautulliId'),
            img: anyNamed('img'),
            ratingKey: anyNamed('ratingKey'),
            fallback: anyNamed('fallback'),
          ),
        );
        // assert
        verify(
          mockGetImageUrl(
            tautulliId: tTautulliId,
            img: anyNamed('img'),
            ratingKey: anyNamed('ratingKey'),
            fallback: anyNamed('fallback'),
          ),
        );
      },
    );

    test(
      'should emit [SyncedItemsSuccess] when data is fetched successfully',
      () async {
        // arrange
        setUpSuccess();
        clearCache();
        // assert later
        final expected = [
          SyncedItemsSuccess(
            list: tSyncedItemsList,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(SyncedItemsFetch(tautulliId: tTautulliId));
      },
    );

    test(
      'should emit [SyncedItemsFailure] with a proper message when getting data fails',
      () async {
        // arrange
        final failure = ServerFailure();
        clearCache();
        when(mockGetSyncedItems(
          tautulliId: anyNamed('tautulliId'),
        )).thenAnswer((_) async => Left(failure));
        // assert later
        final expected = [
          SyncedItemsFailure(
            failure: failure,
            message: SERVER_FAILURE_MESSAGE,
            suggestion: CHECK_SERVER_SETTINGS_SUGGESTION,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(SyncedItemsFetch(tautulliId: tTautulliId));
      },
    );
  });

  group('SyncedItemsFilter', () {
    test(
      'should emit [SyncedItemsInitial] before executing as normal',
      () async {
        // arrange
        setUpSuccess();
        clearCache();
        // assert later
        final expected = [
          SyncedItemsInitial(),
          SyncedItemsSuccess(
            list: tSyncedItemsList,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(SyncedItemsFilter(tautulliId: tTautulliId));
      },
    );
  });
}
