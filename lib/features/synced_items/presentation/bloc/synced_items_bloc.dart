import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../image_url/domain/usecases/get_image_url.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../media/domain/usecases/get_metadata.dart';
import '../../domain/entities/synced_item.dart';
import '../../domain/usecases/get_synced_items.dart';

part 'synced_items_event.dart';
part 'synced_items_state.dart';

List<SyncedItem> _syncedItemsListCache;
String _tautulliIdCache;
int _userIdCache;

class SyncedItemsBloc extends Bloc<SyncedItemsEvent, SyncedItemsState> {
  final GetSyncedItems getSyncedItems;
  final GetMetadata getMetadata;
  final GetImageUrl getImageUrl;
  final Logging logging;

  SyncedItemsBloc({
    @required this.getSyncedItems,
    @required this.getMetadata,
    @required this.getImageUrl,
    @required this.logging,
  }) : super(SyncedItemsInitial(
          tautulliId: _tautulliIdCache,
          userId: _userIdCache,
        ));

  @override
  Stream<SyncedItemsState> mapEventToState(
    SyncedItemsEvent event,
  ) async* {
    if (event is SyncedItemsFetch) {
      _userIdCache = event.userId;

      yield* _fetchSyncedItems(
        tautulliId: event.tautulliId,
        userId: event.userId,
        useCachedList: true,
      );

      _tautulliIdCache = event.tautulliId;
    }
    if (event is SyncedItemsFilter) {
      yield SyncedItemsInitial();
      _userIdCache = event.userId;

      yield* _fetchSyncedItems(
        tautulliId: event.tautulliId,
        userId: event.userId,
      );

      _tautulliIdCache = event.tautulliId;
    }
  }

  Stream<SyncedItemsState> _fetchSyncedItems({
    @required String tautulliId,
    int userId,
    bool useCachedList = false,
  }) async* {
    if (useCachedList &&
        _syncedItemsListCache != null &&
        _tautulliIdCache == tautulliId) {
      yield SyncedItemsSuccess(
        list: _syncedItemsListCache,
      );
    } else {
      final syncedItemsListOrFailure = await getSyncedItems(
        tautulliId: tautulliId,
        userId: userId,
      );

      yield* syncedItemsListOrFailure.fold(
        (failure) async* {
          logging.error(
            'SyncedItems: Failed to load synced item',
          );

          yield SyncedItemsFailure(
            failure: failure,
            message: FailureMapperHelper.mapFailureToMessage(failure),
            suggestion: FailureMapperHelper.mapFailureToSuggestion(failure),
          );
        },
        (list) async* {
          await _getImages(list: list, tautulliId: tautulliId);

          _syncedItemsListCache = list;

          yield SyncedItemsSuccess(
            list: list,
          );
        },
      );
    }
  }

  Future<void> _getImages({
    @required List<SyncedItem> list,
    @required String tautulliId,
  }) async {
    for (SyncedItem syncedItem in list) {
      int grandparentRatingKey;
      String grandparentThumb;
      int parentRatingKey;
      String parentThumb;
      int ratingKey = syncedItem.ratingKey;
      String thumb;

      // If item uses parent or grandparent info for poster then use GetMetadata to fetch correct thumb/rating key
      if (['episode', 'track'].contains(syncedItem.mediaType)) {
        final failureOrMetadata = await getMetadata(
          tautulliId: tautulliId,
          syncId: syncedItem.syncId,
        );

        failureOrMetadata.fold(
          (failure) {
            logging.error(
              'Statistics: Failed to load metadata for ${syncedItem.syncTitle}',
            );
          },
          (item) {
            grandparentRatingKey = item.grandparentRatingKey;
            grandparentThumb = item.grandparentThumb;
            parentRatingKey = item.parentRatingKey;
            parentThumb = item.parentThumb;
            ratingKey = item.ratingKey;
            thumb = item.thumb;
          },
        );
      }

      //* Fetch and assign image URLs
      String posterImg;
      int posterRatingKey;
      String posterFallback;

      // Assign values for poster URL
      switch (syncedItem.mediaType) {
        case ('movie'):
          posterImg = thumb;
          posterRatingKey = ratingKey;
          posterFallback = 'poster';
          break;
        case ('episode'):
          posterImg = grandparentThumb;
          posterRatingKey = grandparentRatingKey;
          posterFallback = 'poster';
          break;
        case ('season'):
          posterImg = parentThumb;
          posterRatingKey = ratingKey;
          posterFallback = 'poster';
          break;
        case ('track'):
          posterImg = thumb;
          posterRatingKey = parentRatingKey;
          posterFallback = 'cover';
          break;
        case ('playlist'):
          posterImg = '/playlists/$ratingKey/composite/69420';
          posterFallback = 'cover';
      }

      // Attempt to get poster URL
      final failureOrPosterUrl = await getImageUrl(
        tautulliId: tautulliId,
        img: posterImg,
        ratingKey: posterRatingKey ?? ratingKey,
        fallback: posterFallback,
      );
      failureOrPosterUrl.fold(
        (failure) {
          logging.warning(
            'Statistics: Failed to load poster for rating key ${posterRatingKey ?? ratingKey}',
          );
        },
        (url) {
          syncedItem.posterUrl = url;
        },
      );
    }
  }
}

void clearCache() {
  _syncedItemsListCache = null;
  _tautulliIdCache = null;
  _userIdCache = null;
}
