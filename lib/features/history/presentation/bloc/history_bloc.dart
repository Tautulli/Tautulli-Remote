import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../image_url/domain/usecases/get_image_url.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../domain/entities/history.dart';
import '../../domain/usecases/get_history.dart';

part 'history_event.dart';
part 'history_state.dart';

List<History> _historyListCache;
bool _hasReachedMaxCache;
int _userIdCache;
String _mediaTypeCache;
String _tautulliIdCache;

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetHistory getHistory;
  final GetImageUrl getImageUrl;
  final Logging logging;

  HistoryBloc({
    @required this.getHistory,
    @required this.getImageUrl,
    @required this.logging,
  }) : super(HistoryInitial(
          userId: _userIdCache,
          mediaType: _mediaTypeCache,
        ));

  @override
  Stream<Transition<HistoryEvent, HistoryState>> transformEvents(
    Stream<HistoryEvent> events,
    transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 25)),
      transitionFn,
    );
  }

  @override
  Stream<HistoryState> mapEventToState(
    HistoryEvent event,
  ) async* {
    final currentState = state;

    if (event is HistoryFetch && !_hasReachedMax(currentState)) {
      if (currentState is HistoryInitial) {
        _userIdCache = event.userId;
        _mediaTypeCache = event.mediaType;

        yield* _fetchInitial(
          tautulliId: event.tautulliId,
          userId: event.userId,
          mediaType: event.mediaType,
          useCachedList: true,
        );

        _tautulliIdCache = event.tautulliId;
      }
      if (currentState is HistorySuccess) {
        _userIdCache = event.userId;
        _mediaTypeCache = event.mediaType;

        yield* _fetchMore(
          currentState: currentState,
          tautulliId: event.tautulliId,
          userId: event.userId,
          mediaType: event.mediaType,
        );

        _tautulliIdCache = event.tautulliId;
      }
    }
    if (event is HistoryFilter) {
      yield HistoryInitial();
      _userIdCache = event.userId;
      _mediaTypeCache = event.mediaType;

      yield* _fetchInitial(
        tautulliId: event.tautulliId,
        userId: event.userId,
        mediaType: event.mediaType,
      );

      _tautulliIdCache = event.tautulliId;
    }
  }

  Stream<HistoryState> _fetchInitial({
    @required String tautulliId,
    int grouping,
    String user,
    int userId,
    int ratingKey,
    int parentRatingKey,
    int grandparentRatingKey,
    String startDate,
    int sectionId,
    String mediaType,
    String transcodeDecision,
    String guid,
    String orderColumn,
    String orderDir,
    int start,
    int length,
    String search,
    bool useCachedList = false,
  }) async* {
    if (useCachedList &&
        _historyListCache != null &&
        _tautulliIdCache == tautulliId) {
      yield HistorySuccess(
        list: _historyListCache,
        hasReachedMax: _hasReachedMaxCache,
      );
    } else {
      final historyOrFailure = await getHistory(
        tautulliId: tautulliId,
        grouping: grouping,
        user: user,
        userId: userId,
        ratingKey: ratingKey,
        parentRatingKey: parentRatingKey,
        grandparentRatingKey: grandparentRatingKey,
        startDate: startDate,
        sectionId: sectionId,
        mediaType: mediaType,
        transcodeDecision: transcodeDecision,
        guid: guid,
        orderColumn: orderColumn,
        orderDir: orderDir,
        start: start,
        length: length ?? 25,
        search: search,
      );

      yield* historyOrFailure.fold(
        (failure) async* {
          yield HistoryFailure(
            failure: failure,
            message: FailureMapperHelper().mapFailureToMessage(failure),
            suggestion: FailureMapperHelper().mapFailureToSuggestion(failure),
          );
        },
        (list) async* {
          await _getImages(list: list, tautulliId: tautulliId);

          _historyListCache = list;
          _hasReachedMaxCache = list.length < 25;

          yield HistorySuccess(
            list: list,
            hasReachedMax: list.length < 25,
          );
        },
      );
    }
  }

  Stream<HistoryState> _fetchMore({
    @required HistorySuccess currentState,
    @required String tautulliId,
    int grouping,
    String user,
    int userId,
    int ratingKey,
    int parentRatingKey,
    int grandparentRatingKey,
    String startDate,
    int sectionId,
    String mediaType,
    String transcodeDecision,
    String guid,
    String orderColumn,
    String orderDir,
    int start,
    int length,
    String search,
  }) async* {
    final historyOrFailure = await getHistory(
      tautulliId: tautulliId,
      grouping: grouping,
      user: user,
      userId: userId,
      ratingKey: ratingKey,
      parentRatingKey: parentRatingKey,
      grandparentRatingKey: grandparentRatingKey,
      startDate: startDate,
      sectionId: sectionId,
      mediaType: mediaType,
      transcodeDecision: transcodeDecision,
      guid: guid,
      orderColumn: orderColumn,
      orderDir: orderDir,
      start: currentState.list.length,
      length: length ?? 25,
      search: search,
    );

    yield* historyOrFailure.fold(
      (failure) async* {
        yield HistoryFailure(
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

          _historyListCache = currentState.list + list;
          _hasReachedMaxCache = list.length < 25;

          yield HistorySuccess(
            list: currentState.list + list,
            hasReachedMax: list.length < 25,
          );
        }
      },
    );
  }

  Future<void> _getImages({
    @required List<History> list,
    @required String tautulliId,
  }) async {
    for (History historyItem in list) {
      //* Fetch and assign image URLs
      String posterImg;
      int posterRatingKey;
      String posterFallback;

      // Assign values for poster URL
      switch (historyItem.mediaType) {
        case ('movie'):
        case ('clip'):
          posterImg = historyItem.thumb;
          posterRatingKey = historyItem.ratingKey;
          posterFallback = 'poster';
          break;
        case ('episode'):
          posterImg = historyItem.thumb;
          posterRatingKey = historyItem.grandparentRatingKey;
          posterFallback = 'poster';
          break;
        case ('track'):
          posterImg = historyItem.thumb;
          posterRatingKey = historyItem.parentRatingKey;
          posterFallback = 'cover';
          break;
        default:
          posterRatingKey = historyItem.ratingKey;
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
          historyItem.posterUrl = url;
        },
      );
    }
  }
}

bool _hasReachedMax(HistoryState state) =>
    state is HistorySuccess && state.hasReachedMax;

void clearCache() {
  _historyListCache = null;
  _hasReachedMaxCache = null;
  _userIdCache = null;
  _mediaTypeCache = null;
}
