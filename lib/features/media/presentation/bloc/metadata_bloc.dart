import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../image_url/domain/usecases/get_image_url.dart';
import '../../domain/entities/metadata_item.dart';
import '../../domain/usecases/get_metadata.dart';

part 'metadata_event.dart';
part 'metadata_state.dart';

String _tautulliIdCache;
Map<int, MetadataItem> _metadataCache = {};

class MetadataBloc extends Bloc<MetadataEvent, MetadataState> {
  final GetMetadata getMetadata;
  final GetImageUrl getImageUrl;

  MetadataBloc({
    @required this.getMetadata,
    @required this.getImageUrl,
  }) : super(MetadataInitial());

  @override
  Stream<MetadataState> mapEventToState(
    MetadataEvent event,
  ) async* {
    if (event is MetadataFetched) {
      if (_tautulliIdCache == event.tautulliId &&
          (_metadataCache.containsKey(event.ratingKey) ||
              _metadataCache.containsKey(event.syncId))) {
        MetadataItem cachedMetadata;
        if (event.ratingKey != null) {
          cachedMetadata = _metadataCache[event.ratingKey];
        } else if (event.syncId != null) {
          cachedMetadata = _metadataCache[event.syncId];
        }
        yield MetadataSuccess(metadata: cachedMetadata);
      } else {
        yield MetadataInProgress();

        final failureorMetadata = await getMetadata(
          tautulliId: event.tautulliId,
          ratingKey: event.ratingKey,
          syncId: event.syncId,
        );

        yield* failureorMetadata.fold(
          (failure) async* {
            yield MetadataFailure(
              failure: failure,
              message: FailureMapperHelper.mapFailureToMessage(failure),
              suggestion: FailureMapperHelper.mapFailureToSuggestion(failure),
            );
          },
          (metadata) async* {
            await _getImages(
              item: metadata,
              tautulliId: event.tautulliId,
            );

            if (event.ratingKey != null) {
              _metadataCache[event.ratingKey] = metadata;
            } else if (event.syncId != null) {
              _metadataCache[event.syncId] = metadata;
            }

            yield MetadataSuccess(metadata: metadata);
          },
        );
      }

      _tautulliIdCache = event.tautulliId;
    }
  }

  Future<void> _getImages({
    @required MetadataItem item,
    @required String tautulliId,
  }) async {
    //* Fetch and assign image URLs
    String posterFallback;

    // Assign values for posterFallback
    switch (item.mediaType) {
      case ('movie'):
      case ('clip'):
        posterFallback = 'poster';
        break;
      case ('episode'):
        posterFallback = 'art';
        break;
      case ('track'):
        posterFallback = 'cover';
        break;
    }

    // Attempt to get poster URL
    final failureOrPosterUrl = await getImageUrl(
      tautulliId: tautulliId,
      img: item.thumb,
      fallback: posterFallback,
    );
    failureOrPosterUrl.fold(
      (failure) {
        // logging.warning('RecentlyAdded: Failed to load poster for rating key: $posterRatingKey');
      },
      (url) {
        item.posterUrl = url;
      },
    );
    final failureOrParentPosterUrl = await getImageUrl(
      tautulliId: tautulliId,
      img: item.parentThumb,
      fallback: posterFallback,
    );
    failureOrParentPosterUrl.fold(
      (failure) {
        // logging.warning('RecentlyAdded: Failed to load poster for rating key: $posterRatingKey');
      },
      (url) {
        item.parentPosterUrl = url;
      },
    );
    final failureOrGrandparentPosterUrl = await getImageUrl(
      tautulliId: tautulliId,
      img: item.grandparentThumb,
      fallback: posterFallback,
    );
    failureOrGrandparentPosterUrl.fold(
      (failure) {
        // logging.warning('RecentlyAdded: Failed to load poster for rating key: $posterRatingKey');
      },
      (url) {
        item.grandparentPosterUrl = url;
      },
    );
  }
}

void clearCache() {
  _metadataCache = {};
  _tautulliIdCache = null;
}
