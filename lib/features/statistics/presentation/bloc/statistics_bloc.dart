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
String _statsTypeCache;
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
        _statsTypeCache = event.statsType;
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

          _noStatsCache = noStats;

          if (noStats) {
            _statisticsMapCache = map;

            yield StatisticsSuccess(
              map: map,
              noStats: noStats,
              hasReachedMaxMap: _hasReachedMaxMapCache,
              lastUpdated: DateTime.now(),
            );
          } else {
            for (String key in map.keys.toList()) {
              map[key] = await _getImages(
                statId: key,
                list: map[key],
                tautulliId: tautulliId,
                settingsBloc: settingsBloc,
              );
            }

            _statisticsMapCache = map;

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
    @required String statId,
    @required SettingsBloc settingsBloc,
  }) async* {
    final failureOrStatistics = await getStatistics(
      tautulliId: _tautulliIdCache,
      statsCount: 25,
      statsType: _statsTypeCache,
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
          map[statId] = await _getImages(
            statId: statId,
            list: map[statId],
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

  Future<List<Statistics>> _getImages({
    // @required Map<String, List<Statistics>> map,
    @required String statId,
    @required List<Statistics> list,
    @required String tautulliId,
    @required SettingsBloc settingsBloc,
  }) async {
    List<Statistics> updatedList = [];
    // for (String key in map.keys.toList()) {
    if (list.length > 0 &&
        !['top_platforms', 'top_users', 'most_concurrent'].contains(statId)) {
      for (Statistics statistic in list) {
        //* Fetch and assign image URLs
        final String posterImg = statistic.statId == 'top_libraries'
            ? statistic.art
            : statistic.thumb;
        final int posterRatingKey = statistic.mediaType == 'episode'
            ? statistic.grandparentRatingKey
            : statistic.ratingKey;
        final String posterFallback =
            statistic.mediaType == 'track' ? 'cover' : 'poster';

        String posterUrl;
        String iconUrl;

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
            posterUrl = url;
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
              iconUrl = url;
            },
          );
        }
        updatedList.add(
          statistic.copyWith(posterUrl: posterUrl, iconUrl: iconUrl),
        );
      }
    } else {
      return list;
    }
    // }
    return updatedList;
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
