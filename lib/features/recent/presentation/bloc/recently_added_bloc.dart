import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../image_url/domain/usecases/get_image_url.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../domain/entities/recent.dart';
import '../../domain/usecases/get_recently_added.dart';

part 'recently_added_event.dart';
part 'recently_added_state.dart';

class RecentlyAddedBloc extends Bloc<RecentlyAddedEvent, RecentlyAddedState> {
  final GetRecentlyAdded recentlyAdded;
  final GetImageUrl getImageUrl;
  final Logging logging;

  RecentlyAddedBloc({
    @required this.recentlyAdded,
    @required this.getImageUrl,
    @required this.logging,
  }) : super(RecentlyAddedInitial());

  @override
  Stream<Transition<RecentlyAddedEvent, RecentlyAddedState>> transformEvents(
    Stream<RecentlyAddedEvent> events,
    TransitionFunction<RecentlyAddedEvent, RecentlyAddedState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<RecentlyAddedState> mapEventToState(
    RecentlyAddedEvent event,
  ) async* {
    final currentState = state;

    if (event is RecentlyAddedFetched && !_hasReachedMax(currentState)) {
      if (currentState is RecentlyAddedInitial) {
        if (event.mediaType == 'all') {
          yield* _fetchFixed(
            tautulliId: event.tautulliId,
          );
        } else {
          yield* _fetchInitial(
            tautulliId: event.tautulliId,
            mediaType: event.mediaType,
          );
        }
      }
      if (currentState is RecentlyAddedSuccess) {
        yield* _fetchMore(
          tautulliId: event.tautulliId,
          currentState: currentState,
          mediaType: event.mediaType,
        );
      }
    }
    if (event is RecentlyAddedFilter) {
      yield RecentlyAddedInitial();
      if (event.mediaType == 'all') {
        yield* _fetchFixed(tautulliId: event.tautulliId);
      } else {
        yield* _fetchInitial(
          tautulliId: event.tautulliId,
          mediaType: event.mediaType,
        );
      }
    }
  }

  Stream<RecentlyAddedState> _fetchFixed({
    @required String tautulliId,
  }) async* {
    final recentListOrFailure = await recentlyAdded(
      tautulliId: tautulliId,
      count: 50,
    );

    yield* recentListOrFailure.fold(
      (failure) async* {
        yield RecentlyAddedFailure(
          failure: failure,
          message: FailureMapperHelper().mapFailureToMessage(failure),
          suggestion: FailureMapperHelper().mapFailureToSuggestion(failure),
        );
      },
      (list) async* {
        await _getImages(list: list, tautulliId: tautulliId);

        yield RecentlyAddedSuccess(
          list: list,
          hasReachedMax: true,
        );
      },
    );
  }

  Stream<RecentlyAddedState> _fetchInitial({
    @required String tautulliId,
    String mediaType,
  }) async* {
    final recentListOrFailure = await recentlyAdded(
      tautulliId: tautulliId,
      count: 10,
      mediaType: mediaType,
    );

    yield* recentListOrFailure.fold(
      (failure) async* {
        yield RecentlyAddedFailure(
          failure: failure,
          message: FailureMapperHelper().mapFailureToMessage(failure),
          suggestion: FailureMapperHelper().mapFailureToSuggestion(failure),
        );
      },
      (list) async* {
        await _getImages(list: list, tautulliId: tautulliId);

        yield RecentlyAddedSuccess(
          list: list,
          hasReachedMax: list.length < 10,
        );
      },
    );
  }

  Stream<RecentlyAddedState> _fetchMore({
    @required String tautulliId,
    @required RecentlyAddedSuccess currentState,
    String mediaType,
  }) async* {
    final recentListOrFailure = await recentlyAdded(
      tautulliId: tautulliId,
      count: 15,
      start: currentState.list.length,
      mediaType: mediaType,
    );

    yield* recentListOrFailure.fold(
      (failure) async* {
        yield RecentlyAddedFailure(
          failure: failure,
          message: FailureMapperHelper().mapFailureToMessage(failure),
          suggestion: FailureMapperHelper().mapFailureToSuggestion(failure),
        );
      },
      (list) async* {
        if (list.isEmpty) {
          yield currentState.copyWith(hasReachedMax: true);
        } else {
          await _getImages(list: list, tautulliId: tautulliId);

          yield RecentlyAddedSuccess(
            list: currentState.list + list,
            hasReachedMax: list.length < 10,
          );
        }
      },
    );
  }

  Future<void> _getImages({
    @required List<RecentItem> list,
    @required String tautulliId,
  }) async {
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
      );
      failureOrPosterUrl.fold(
        (failure) {
          logging.warning(
              'RecentlyAdded: Failed to load poster for rating key: $posterRatingKey');
        },
        (url) {
          recentItem.posterUrl = url;
        },
      );
    }
  }
}

bool _hasReachedMax(RecentlyAddedState state) =>
    state is RecentlyAddedSuccess && state.hasReachedMax;
