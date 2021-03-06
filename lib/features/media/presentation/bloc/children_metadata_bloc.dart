import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../image_url/domain/usecases/get_image_url.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
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
  final Logging logging;

  ChildrenMetadataBloc({
    @required this.getChildrenMetadata,
    @required this.getImageUrl,
    @required this.logging,
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
          mediaType: event.mediaType,
          settingsBloc: event.settingsBloc,
        );

        yield* failureOrChildrenMetadata.fold(
          (failure) async* {
            logging.error(
              'ChildrenMetadata: Failed to fetch children metadata for rating key ${event.ratingKey}',
            );

            yield ChildrenMetadataFailure(
              failure: failure,
              message: FailureMapperHelper.mapFailureToMessage(failure),
              suggestion: FailureMapperHelper.mapFailureToSuggestion(failure),
            );
          },
          (childrenMetadataList) async* {
            if (childrenMetadataList.isNotEmpty) {
              String mediaType;
              if (event.mediaType == 'playlist') {
                mediaType = 'playlist';
              } else {
                mediaType = childrenMetadataList.first.mediaType;
              }

              await _sortList(
                mediaType: mediaType,
                childrenMetadataList: childrenMetadataList,
              );

              List<MetadataItem> updatedList = await _getImages(
                list: childrenMetadataList,
                tautulliId: event.tautulliId,
                settingsBloc: event.settingsBloc,
              );

              _metadataCache[event.ratingKey] = updatedList;

              yield ChildrenMetadataSuccess(
                childrenMetadataList: updatedList,
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
    // Sort by year if album leave sort alone if movie/show/artist/playlist
    // and by mediaIndex for everything else
    if (mediaType == 'album') {
      childrenMetadataList.sort((a, b) {
        if (a.year != null && b.year != null) {
          return b.year.compareTo(a.year);
        }
        return 0;
      });
    } else if (!['movie', 'show', 'artist', 'playlist'].contains(mediaType)) {
      childrenMetadataList.sort((a, b) => a.mediaIndex.compareTo(b.mediaIndex));
    }
  }

  Future<List<MetadataItem>> _getImages({
    @required List<MetadataItem> list,
    @required String tautulliId,
    @required SettingsBloc settingsBloc,
  }) async {
    List<MetadataItem> updatedList = [];

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
        settingsBloc: settingsBloc,
      );
      failureOrPosterUrl.fold(
        (failure) {
          logging.warning(
            'ChildrenMetadata: Failed to load poster for ${metadataItem.thumb}',
          );
        },
        (url) {
          updatedList.add(metadataItem.copyWith(posterUrl: url));
        },
      );
    }
    return updatedList;
  }
}

void clearCache() {
  _metadataCache = {};
  _tautulliIdCache = null;
}
