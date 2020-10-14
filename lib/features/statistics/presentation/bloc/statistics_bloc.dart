import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../image_url/domain/usecases/get_image_url.dart';
import '../../domain/entities/statistics.dart';
import '../../domain/usecases/get_statistics.dart';

part 'statistics_event.dart';
part 'statistics_state.dart';

Map<String, List<Statistics>> _statisticsMapCache;
Map<String, bool> _hasReachedMaxMapCache = {};
bool _noStatsCache;
String _statsTypeCache;
int _timeRangeCache;
String _tautulliIdCache;

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final GetStatistics getStatistics;
  final GetImageUrl getImageUrl;

  StatisticsBloc({
    @required this.getStatistics,
    @required this.getImageUrl,
  }) : super(StatisticsInitial(
          statsType: _statsTypeCache,
          timeRange: _timeRangeCache,
        ));

  @override
  Stream<StatisticsState> mapEventToState(
    StatisticsEvent event,
  ) async* {
    final currentState = state;

    if (event is StatisticsFetch) {
      if (event.statId == null) {
        _statsTypeCache = event.statsType;
        _timeRangeCache = event.timeRange;

        yield* _fetchInitial(
          tautulliId: event.tautulliId,
          grouping: event.grouping,
          statsCount: event.statsCount,
          statsType: event.statsType,
          timeRange: event.timeRange > 0 ? event.timeRange : 30,
          useCachedList: true,
        );
      } else {
        if (!_hasReachedMax(currentState, event.statId)) {
          yield* _fetchMore(
            currentState: currentState,
            statId: event.statId,
          );
        }
      }

      _tautulliIdCache = event.tautulliId;
    }
    if (event is StatisticsFilter) {
      yield StatisticsInitial();
      _statsTypeCache = event.statsType;
      _timeRangeCache = event.timeRange;

      yield* _fetchInitial(
        tautulliId: event.tautulliId,
        grouping: event.grouping,
        statsCount: event.statsCount,
        statsType: event.statsType,
        timeRange: event.timeRange > 0 ? event.timeRange : 30,
      );

      _tautulliIdCache = event.tautulliId;
    }
  }

  Stream<StatisticsState> _fetchInitial({
    @required String tautulliId,
    int grouping,
    int timeRange,
    String statsType,
    int statsCount,
    bool useCachedList = false,
  }) async* {
    if (useCachedList &&
        _statisticsMapCache != null &&
        tautulliId == _tautulliIdCache) {
      yield StatisticsSuccess(
        map: _statisticsMapCache,
        noStats: _noStatsCache,
        hasReachedMaxMap: _hasReachedMaxMapCache,
        lastUpdated: DateTime.now(),
      );
    } else {
      final statisticsOrFailure = await getStatistics(
        tautulliId: tautulliId,
        grouping: grouping,
        statsCount: statsCount ?? 6,
        statsType: statsType,
        timeRange: timeRange,
      );

      yield* statisticsOrFailure.fold(
        (failure) async* {
          yield StatisticsFailure(
            failure: failure,
            message: FailureMapperHelper.mapFailureToMessage(failure),
            suggestion: FailureMapperHelper.mapFailureToSuggestion(failure),
          );
        },
        (map) async* {
          // Check if all stats are empty and build hasReachedMaxMap
          final List keys = map.keys.toList();
          bool noStats = true;
          for (String key in keys) {
            if (map[key].length > 0) {
              noStats = false;
              // break;
            }

            if (map[key].length < 6) {
              _hasReachedMaxMapCache[key] = true;
            } else {
              _hasReachedMaxMapCache[key] = false;
            }
          }

          _statisticsMapCache = map;
          _noStatsCache = noStats;

          if (noStats) {
            yield StatisticsSuccess(
              map: map,
              noStats: noStats,
              hasReachedMaxMap: _hasReachedMaxMapCache,
              lastUpdated: DateTime.now(),
            );
          } else {
            await _getImages(
              map: map,
              tautulliId: tautulliId,
            );

            yield StatisticsSuccess(
              map: map,
              noStats: noStats,
              hasReachedMaxMap: _hasReachedMaxMapCache,
              lastUpdated: DateTime.now(),
            );
          }
        },
      );
    }
  }

  Stream<StatisticsState> _fetchMore({
    @required StatisticsSuccess currentState,
    String statId,
  }) async* {
    final statisticsOrFailure = await getStatistics(
      tautulliId: _tautulliIdCache,
      statsCount: 25,
      statsType: _statsTypeCache,
      timeRange: _timeRangeCache,
      statsStart: currentState.map[statId].length,
      statId: statId,
    );

    yield* statisticsOrFailure.fold(
      (failure) async* {
        yield StatisticsFailure(
          failure: failure,
          message: FailureMapperHelper.mapFailureToMessage(failure),
          suggestion: FailureMapperHelper.mapFailureToSuggestion(failure),
        );
      },
      (map) async* {
        if (map[statId].isEmpty) {
          _hasReachedMaxMapCache[statId] = true;
          yield currentState.copyWith(
            hasReachedMaxMap: _hasReachedMaxMapCache,
            lastUpdated: DateTime.now(),
          );
        } else {
          await _getImages(
            map: map,
            tautulliId: _tautulliIdCache,
          );

          _statisticsMapCache[statId] = currentState.map[statId] + map[statId];
          _hasReachedMaxMapCache[statId] = map[statId].length < 25;

          yield StatisticsSuccess(
            map: _statisticsMapCache,
            noStats: _noStatsCache,
            hasReachedMaxMap: _hasReachedMaxMapCache,
            lastUpdated: DateTime.now(),
          );
        }
      },
    );
  }

  Future<void> _getImages({
    @required Map<String, List<Statistics>> map,
    @required String tautulliId,
  }) async {
    for (String key in map.keys.toList()) {
      if (map[key].length > 0 &&
          key != 'top_platforms' &&
          key != 'top_users' &&
          key != 'most_concurrent') {
        for (Statistics statistic in map[key]) {
          //* Fetch and assign image URLs
          String posterImg;
          int posterRatingKey;
          String posterFallback;

          // Assign values for poster URL
          switch (statistic.mediaType) {
            case ('movie'):
              posterImg = statistic.thumb;
              posterRatingKey = statistic.ratingKey;
              posterFallback = 'poster';
              break;
            case ('episode'):
              posterImg = statistic.grandparentThumb;
              // posterRatingKey = statistic.grandparentRatingKey;
              posterFallback = 'poster';
              break;
            case ('track'):
              posterImg = statistic.thumb;
              // posterRatingKey = statistic.parentRatingKey;
              posterFallback = 'cover';
              break;
            default:
              posterRatingKey = statistic.ratingKey;
          }

          // Attempt to get poster URL
          final failureOrPosterUrl = await getImageUrl(
            tautulliId: tautulliId,
            img: posterImg,
            ratingKey: posterRatingKey,
            fallback: posterFallback,
          );
          failureOrPosterUrl.fold(
            (failure) => null,
            (url) {
              statistic.posterUrl = url;
            },
          );
        }
      }
    }
  }
}

bool _hasReachedMax(StatisticsState state, String statId) =>
    state is StatisticsSuccess && state.hasReachedMaxMap[statId];

void clearCache() {
  _statisticsMapCache = null;
  _noStatsCache = null;
  _statsTypeCache = null;
  _timeRangeCache = null;
  _tautulliIdCache = null;
}
