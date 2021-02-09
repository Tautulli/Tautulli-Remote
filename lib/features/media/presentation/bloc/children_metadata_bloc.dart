import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../image_url/domain/usecases/get_image_url.dart';
import '../../domain/entities/metadata_item.dart';
import '../../domain/usecases/get_children_metadata.dart';

part 'children_metadata_event.dart';
part 'children_metadata_state.dart';

String _tautulliIdCache;
Map<int, List<MetadataItem>> _metadataCache = {};

class ChildrenMetadataBloc
    extends Bloc<ChildrenMetadataEvent, ChildrenMetadataState> {
  final GetChildrenMetadata getChildrenMetadata;
  final GetImageUrl getImageUrl;

  ChildrenMetadataBloc({
    @required this.getChildrenMetadata,
    @required this.getImageUrl,
  }) : super(ChildrenMetadataInitial());

  @override
  Stream<ChildrenMetadataState> mapEventToState(
    ChildrenMetadataEvent event,
  ) async* {
    if (event is ChildrenMetadataFetched) {
      if (_tautulliIdCache == event.tautulliId &&
          _metadataCache.containsKey(event.ratingKey)) {
        yield ChildrenMetadataSuccess(
          childrenMetadataList: _metadataCache[event.ratingKey],
        );
      } else {
        yield ChildrenMetadataInProgress();

        final failureOrChildrenMetadata = await getChildrenMetadata(
          tautulliId: event.tautulliId,
          ratingKey: event.ratingKey,
        );

        yield* failureOrChildrenMetadata.fold(
          (failure) async* {
            yield ChildrenMetadataFailure(
              failure: failure,
              message: FailureMapperHelper.mapFailureToMessage(failure),
              suggestion: FailureMapperHelper.mapFailureToSuggestion(failure),
            );
          },
          (childrenMetadataList) async* {
            if (childrenMetadataList.isNotEmpty) {
              final String mediaType = childrenMetadataList.first.mediaType;

              await _sortList(
                mediaType: mediaType,
                childrenMetadataList: childrenMetadataList,
              );

              await _getImages(
                list: childrenMetadataList,
                tautulliId: event.tautulliId,
              );

              _metadataCache[event.ratingKey] = childrenMetadataList;

              yield ChildrenMetadataSuccess(
                childrenMetadataList: childrenMetadataList,
              );
            }
          },
        );
      }
    }
  }

  Future<void> _sortList({
    @required String mediaType,
    @required List<MetadataItem> childrenMetadataList,
  }) async {
    // Sort by year if album leave sort alone if movie/show/artist
    // and by mediaIndex for everything else
    if (mediaType == 'album') {
      childrenMetadataList.sort((a, b) => b.year.compareTo(a.year));
    } else if (!['movie', 'show', 'artist'].contains(mediaType)) {
      childrenMetadataList.sort((a, b) => a.mediaIndex.compareTo(b.mediaIndex));
    }
  }

  Future<void> _getImages({
    @required List<MetadataItem> list,
    @required String tautulliId,
  }) async {
    for (MetadataItem metadataItem in list) {
      //* Fetch and assign image URLs
      String posterFallback;

      // Assign values for posterFallback
      switch (metadataItem.mediaType) {
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
        img: metadataItem.thumb,
        fallback: posterFallback,
      );
      failureOrPosterUrl.fold(
        (failure) {
          // logging.warning('RecentlyAdded: Failed to load poster for rating key: $posterRatingKey');
        },
        (url) {
          metadataItem.posterUrl = url;
        },
      );
    }
  }
}

void clearCache() {
  _metadataCache = {};
  _tautulliIdCache = null;
}
