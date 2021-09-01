// @dart=2.9

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../image_url/domain/usecases/get_image_url.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/recent.dart';
import '../../domain/usecases/get_recently_added.dart';

part 'libraries_recently_added_event.dart';
part 'libraries_recently_added_state.dart';

Map<String, List<RecentItem>> _librariesRecentListCacheMap = {};
bool _hasReachedMaxCache;

class LibrariesRecentlyAddedBloc
    extends Bloc<LibrariesRecentlyAddedEvent, LibrariesRecentlyAddedState> {
  final GetRecentlyAdded recentlyAdded;
  final GetImageUrl getImageUrl;
  final Logging logging;

  LibrariesRecentlyAddedBloc({
    @required this.recentlyAdded,
    @required this.getImageUrl,
    @required this.logging,
  }) : super(LibrariesRecentlyAddedInitial());

  @override
  Stream<Transition<LibrariesRecentlyAddedEvent, LibrariesRecentlyAddedState>>
      transformEvents(
    Stream<LibrariesRecentlyAddedEvent> events,
    TransitionFunction<LibrariesRecentlyAddedEvent, LibrariesRecentlyAddedState>
        transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 30)),
      transitionFn,
    );
  }

  @override
  Stream<LibrariesRecentlyAddedState> mapEventToState(
    LibrariesRecentlyAddedEvent event,
  ) async* {
    final currentState = state;

    if (event is LibrariesRecentlyAddedFetch && !_hasReachedMax(currentState)) {
      if (currentState is LibrariesRecentlyAddedInitial) {
        if (_librariesRecentListCacheMap
                .containsKey('${event.tautulliId}:${event.sectionId}') &&
            _librariesRecentListCacheMap[
                    '${event.tautulliId}:${event.sectionId}'] !=
                null) {
          yield LibrariesRecentlyAddedSuccess(
            list: _librariesRecentListCacheMap[
                '${event.tautulliId}:${event.sectionId}'],
            hasReachedMax: _hasReachedMaxCache,
          );
        } else {
          final failureOrRecentList = await recentlyAdded(
            tautulliId: event.tautulliId,
            count: 25,
            sectionId: event.sectionId,
            settingsBloc: event.settingsBloc,
          );

          yield* failureOrRecentList.fold(
            (failure) async* {
              logging.error(
                'RecentlyAdded: Failed to fetch recently added items for library ID: ${event.sectionId}',
              );

              yield LibrariesRecentlyAddedFailure(
                failure: failure,
                message: FailureMapperHelper.mapFailureToMessage(failure),
                suggestion: FailureMapperHelper.mapFailureToSuggestion(failure),
              );
            },
            (list) async* {
              List<RecentItem> updatedList = await _getImages(
                list: list,
                tautulliId: event.tautulliId,
                settingsBloc: event.settingsBloc,
              );

              _librariesRecentListCacheMap[
                  '${event.tautulliId}:${event.sectionId}'] = updatedList;
              _hasReachedMaxCache = updatedList.length < 25;

              yield LibrariesRecentlyAddedSuccess(
                list: updatedList,
                hasReachedMax: updatedList.length < 25,
              );
            },
          );
        }
      }
      if (currentState is LibrariesRecentlyAddedSuccess) {
        final failureOrRecentList = await recentlyAdded(
          tautulliId: event.tautulliId,
          count: 25,
          start: currentState.list.length,
          sectionId: event.sectionId,
          settingsBloc: event.settingsBloc,
        );

        yield* failureOrRecentList.fold(
          (failure) async* {
            logging.error(
              'RecentlyAdded: Failed to fetch recently added items for library ${event.sectionId}',
            );

            yield LibrariesRecentlyAddedFailure(
              failure: failure,
              message: FailureMapperHelper.mapFailureToMessage(failure),
              suggestion: FailureMapperHelper.mapFailureToSuggestion(failure),
            );
          },
          (list) async* {
            if (list.isEmpty) {
              yield currentState.copyWith(hasReachedMax: true);
            } else {
              List<RecentItem> updatedList = await _getImages(
                list: list,
                tautulliId: event.tautulliId,
                settingsBloc: event.settingsBloc,
              );

              _librariesRecentListCacheMap[
                      '${event.tautulliId}:${event.sectionId}'] =
                  currentState.list + updatedList;
              _hasReachedMaxCache = updatedList.length < 25;

              yield LibrariesRecentlyAddedSuccess(
                list: currentState.list + updatedList,
                hasReachedMax: updatedList.length < 25,
              );
            }
          },
        );
      }
    }
  }

  Future<List<RecentItem>> _getImages({
    @required List<RecentItem> list,
    @required String tautulliId,
    @required SettingsBloc settingsBloc,
  }) async {
    List<RecentItem> updatedList = [];

    for (RecentItem recentItem in list) {
      //* Fetch and assign image URLs
      String posterImg;
      int posterRatingKey;
      String posterFallback;

      // Assign values for poster URL
      switch (recentItem.mediaType) {
        case ('movie'):
          posterImg = recentItem.thumb;
          posterRatingKey = recentItem.ratingKey;
          posterFallback = 'poster';
          break;
        case ('episode'):
          posterImg = recentItem.grandparentThumb;
          posterRatingKey = recentItem.grandparentRatingKey;
          posterFallback = 'poster';
          break;
        case ('season'):
          posterImg = recentItem.parentThumb;
          posterRatingKey = recentItem.ratingKey;
          posterFallback = 'poster';
          break;
        case ('track'):
          posterImg = recentItem.thumb;
          posterRatingKey = recentItem.parentRatingKey;
          posterFallback = 'cover';
          break;
        default:
          posterRatingKey = recentItem.ratingKey;
      }

      // Attempt to get poster URL
      final failureOrPosterUrl = await getImageUrl(
        tautulliId: tautulliId,
        img: posterImg,
        ratingKey: posterRatingKey,
        fallback: posterFallback,
        settingsBloc: settingsBloc,
      );
      failureOrPosterUrl.fold(
        (failure) {
          logging.warning(
            'RecentlyAdded: Failed to load poster for rating key $posterRatingKey',
          );
        },
        (url) {
          updatedList.add(recentItem.copyWith(posterUrl: url));
        },
      );
    }
    return updatedList;
  }
}

bool _hasReachedMax(LibrariesRecentlyAddedState state) =>
    state is LibrariesRecentlyAddedSuccess && state.hasReachedMax;

void clearCache() {
  _librariesRecentListCacheMap = {};
  _hasReachedMaxCache = null;
}
