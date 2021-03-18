import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../image_url/domain/usecases/get_image_url.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/statistics.dart';
import '../../domain/usecases/get_statistics.dart';

part 'statistics_event.dart';
part 'statistics_state.dart';

Map<String, List<Statistics>> _statisticsMapCache;
Map<String, bool> _hasReachedMaxMapCache = {};
bool _noStatsCache;
int _timeRangeCache;
String _tautulliIdCache;
SettingsBloc _settingsBlocCache;

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final GetStatistics getStatistics;
  final GetImageUrl getImageUrl;
  final Logging logging;

  StatisticsBloc({
    @required this.getStatistics,
    @required this.getImageUrl,
    @required this.logging,
  }) : super(StatisticsInitial(
          timeRange: _timeRangeCache,
        ));

  @override
  Stream<StatisticsState> mapEventToState(
    StatisticsEvent event,
  ) async* {
    final currentState = state;

    if (event is StatisticsFetch) {
      _settingsBlocCache = event.settingsBloc;

      if (event.statId == null) {
        _timeRangeCache = event.timeRange;

        yield* _fetchInitial(
          tautulliId: event.tautulliId,
          grouping: event.grouping,
          statsCount: event.statsCount,
          statsType: event.statsType,
          timeRange: event.timeRange > 0 ? event.timeRange : 30,
          useCachedList: true,
          settingsBloc: _settingsBlocCache,
        );
      } else {
        if (!_hasReachedMax(currentState, event.statId)) {
          yield* _fetchMore(
            currentState: currentState,
            statId: event.statId,
            settingsBloc: _settingsBlocCache,
          );
        }
      }

      _tautulliIdCache = event.tautulliId;
    }
    if (event is StatisticsFilter) {
      yield StatisticsInitial();
      _timeRangeCache = event.timeRange;

      yield* _fetchInitial(
        tautulliId: event.tautulliId,
        grouping: event.grouping,
        statsCount: event.statsCount,
        statsType: event.statsType,
        timeRange: event.timeRange > 0 ? event.timeRange : 30,
        settingsBloc: _settingsBlocCache,
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
    @required SettingsBloc settingsBloc,
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
      final failureOrStatistics = await getStatistics(
        tautulliId: tautulliId,
        grouping: grouping,
        statsCount: statsCount ?? 6,
        statsType: statsType,
        timeRange: timeRange,
        settingsBloc: settingsBloc,
      );

      yield* failureOrStatistics.fold(
        (failure) async* {
          logging.error(
            'Statistics: Failed to fetch statistics',
          );

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
              settingsBloc: settingsBloc,
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
    @required SettingsBloc settingsBloc,
  }) async* {
    final failureOrStatistics = await getStatistics(
      tautulliId: _tautulliIdCache,
      statsCount: 25,
      timeRange: _timeRangeCache,
      statsStart: currentState.map[statId].length,
      statId: statId,
      settingsBloc: settingsBloc,
    );

    yield* failureOrStatistics.fold(
      (failure) async* {
        logging.error(
          'Statistics: Failed to fetch additional statistics',
        );

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
            settingsBloc: settingsBloc,
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
    @required SettingsBloc settingsBloc,
  }) async {
    for (String key in map.keys.toList()) {
      if (map[key].length > 0 &&
          key != 'top_platforms' &&
          key != 'top_users' &&
          key != 'most_concurrent') {
        for (Statistics statistic in map[key]) {
          //* Fetch and assign image URLs
          final String posterImg = statistic.statId == 'top_libraries'
              ? statistic.art
              : statistic.thumb;
          final int posterRatingKey = statistic.mediaType == 'episode'
              ? statistic.grandparentRatingKey
              : statistic.ratingKey;
          final String posterFallback =
              statistic.mediaType == 'track' ? 'cover' : 'poster';

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
                'Statistics: Failed to load poster for rating key $posterRatingKey',
              );
            },
            (url) {
              statistic.posterUrl = url;
            },
          );

          // If library stat and custom icon is set fetch the image url
          if (statistic.statId == 'top_libraries' &&
              statistic.thumb.contains('http')) {
            final failureOrIconUrl = await getImageUrl(
              tautulliId: tautulliId,
              img: statistic.thumb,
              settingsBloc: settingsBloc,
            );

            failureOrIconUrl.fold(
              (failure) {
                logging.warning(
                  'Statistics: Failed to load icon for library ${statistic.sectionName}',
                );
              },
              (url) {
                statistic.iconUrl = url;
              },
            );
          }
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
  _timeRangeCache = null;
  _tautulliIdCache = null;
}
