import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../image_url/domain/usecases/get_image_url.dart';
import '../../domain/entities/library_media.dart';
import '../../domain/usecases/get_library_media_info.dart';

part 'library_media_event.dart';
part 'library_media_state.dart';

String _tautulliIdCache;
Map<int, List<LibraryMedia>> _libraryMediaListCache = {};
bool _hasReachedMaxCache;

class LibraryMediaBloc extends Bloc<LibraryMediaEvent, LibraryMediaState> {
  final GetLibraryMediaInfo getLibraryMediaInfo;
  final GetImageUrl getImageUrl;

  LibraryMediaBloc({
    @required this.getLibraryMediaInfo,
    @required this.getImageUrl,
  }) : super(LibraryMediaInitial());

  @override
  Stream<Transition<LibraryMediaEvent, LibraryMediaState>> transformEvents(
    Stream<LibraryMediaEvent> events,
    transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 25)),
      transitionFn,
    );
  }

  @override
  Stream<LibraryMediaState> mapEventToState(
    LibraryMediaEvent event,
  ) async* {
    final currentState = state;

    if (event is LibraryMediaFetched && !_hasReachedMax(currentState)) {
      if (currentState is LibraryMediaInitial) {
        yield LibraryMediaInProgress();

        yield* _fetchInitial(
          tautulliId: event.tautulliId,
          ratingKey: event.ratingKey,
          sectionId: event.sectionId,
          useCachedList: true,
        );
      }
      if (currentState is LibraryMediaSuccess) {
        yield* _fetchMore(
          currentState: currentState,
          tautulliId: event.tautulliId,
          ratingKey: event.ratingKey,
          sectionId: event.sectionId,
        );
      }

      _tautulliIdCache = event.tautulliId;
    }
  }

  Stream<LibraryMediaState> _fetchInitial({
    @required String tautulliId,
    int ratingKey,
    int sectionId,
    int start,
    int length,
    bool useCachedList = false,
  }) async* {
    if (useCachedList &&
        _tautulliIdCache == tautulliId &&
        (_libraryMediaListCache.containsKey(ratingKey) ||
            _libraryMediaListCache.containsKey(sectionId))) {
      List<LibraryMedia> cachedList = [];
      if (ratingKey != null) {
        cachedList = _libraryMediaListCache[ratingKey];
      } else if (sectionId != null) {
        cachedList = _libraryMediaListCache[sectionId];
      }
      yield LibraryMediaSuccess(
        libraryMediaList: cachedList,
        hasReachedMax: cachedList.length < 25,
      );
    } else {
      final failureOrLibraryMediaList = await getLibraryMediaInfo(
        tautulliId: tautulliId,
        ratingKey: ratingKey,
        sectionId: sectionId,
        start: start,
        length: length ?? 25,
      );

      yield* failureOrLibraryMediaList.fold(
        (failure) async* {
          yield LibraryMediaFailure(
            failure: failure,
            message: FailureMapperHelper.mapFailureToMessage(failure),
            suggestion: FailureMapperHelper.mapFailureToSuggestion(failure),
          );
        },
        (libraryMediaList) async* {
          final String mediaType = libraryMediaList.first.mediaType;

          await _sortList(
            mediaType: mediaType,
            libraryMediaList: libraryMediaList,
          );

          await _getImages(list: libraryMediaList, tautulliId: tautulliId);

          if (ratingKey != null) {
            _libraryMediaListCache[ratingKey] = libraryMediaList;
          } else if (sectionId != null) {
            _libraryMediaListCache[sectionId] = libraryMediaList;
          }

          _hasReachedMaxCache = libraryMediaList.length < 25;

          yield LibraryMediaSuccess(
            libraryMediaList: libraryMediaList,
            hasReachedMax: libraryMediaList.length < 25,
          );
        },
      );
    }
  }

  Stream<LibraryMediaState> _fetchMore({
    @required LibraryMediaSuccess currentState,
    @required String tautulliId,
    int ratingKey,
    int sectionId,
    int start,
    int length,
  }) async* {
    final failureOrLibraryMediaList = await getLibraryMediaInfo(
      tautulliId: tautulliId,
      ratingKey: ratingKey,
      sectionId: sectionId,
      start: currentState.libraryMediaList.length,
      length: length ?? 25,
    );

    yield* failureOrLibraryMediaList.fold(
      (failure) async* {
        yield LibraryMediaFailure(
          failure: failure,
          message: FailureMapperHelper.mapFailureToMessage(failure),
          suggestion: FailureMapperHelper.mapFailureToSuggestion(failure),
        );
      },
      (libraryMediaList) async* {
        if (libraryMediaList.isEmpty) {
          _hasReachedMaxCache = true;
          yield currentState.copyWith(hasReachedMax: true);
        } else {
          final String mediaType = libraryMediaList[0].mediaType;

          await _sortList(
            mediaType: mediaType,
            libraryMediaList: libraryMediaList,
          );

          await _getImages(list: libraryMediaList, tautulliId: tautulliId);

          if (ratingKey != null) {
            _libraryMediaListCache[ratingKey] =
                currentState.libraryMediaList + libraryMediaList;
          } else if (sectionId != null) {
            _libraryMediaListCache[sectionId] =
                currentState.libraryMediaList + libraryMediaList;
          }

          _hasReachedMaxCache = libraryMediaList.length < 25;

          yield LibraryMediaSuccess(
            libraryMediaList: currentState.libraryMediaList + libraryMediaList,
            hasReachedMax: libraryMediaList.length < 25,
          );
        }
      },
    );
  }

  Future<void> _sortList({
    @required String mediaType,
    @required List<LibraryMedia> libraryMediaList,
  }) async {
    // Sort by year if album leave sort alone if movie/show/artist
    // and by mediaIndex for everything else
    if (mediaType == 'album') {
      libraryMediaList.sort((a, b) => b.year.compareTo(a.year));
    } else if (!['movie', 'show', 'artist'].contains(mediaType)) {
      libraryMediaList.sort((a, b) => a.mediaIndex.compareTo(b.mediaIndex));
    }
  }

  Future<void> _getImages({
    @required List<LibraryMedia> list,
    @required String tautulliId,
  }) async {
    for (LibraryMedia libraryMediaItem in list) {
      //* Fetch and assign image URLs
      String posterFallback;

      // Assign values for posterFallback
      switch (libraryMediaItem.mediaType) {
        case ('movie'):
        case ('clip'):
          posterFallback = 'poster';
          break;
        case ('episode'):
          posterFallback = 'poster';
          break;
        case ('track'):
          posterFallback = 'cover';
          break;
      }

      // Attempt to get poster URL
      final failureOrPosterUrl = await getImageUrl(
        tautulliId: tautulliId,
        img: libraryMediaItem.thumb,
        fallback: posterFallback,
      );
      failureOrPosterUrl.fold(
        (failure) {
          // logging.warning('RecentlyAdded: Failed to load poster for rating key: $posterRatingKey');
        },
        (url) {
          libraryMediaItem.posterUrl = url;
        },
      );
    }
  }
}

bool _hasReachedMax(LibraryMediaState state) =>
    state is LibraryMediaSuccess && state.hasReachedMax;

void clearCache() {
  _tautulliIdCache = null;
  _libraryMediaListCache = {};
  _hasReachedMaxCache = null;
}
