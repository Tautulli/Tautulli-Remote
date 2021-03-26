import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/user_statistic.dart';
import '../../domain/usecases/get_user_player_stats.dart';
import '../../domain/usecases/get_user_watch_time_stats.dart';

part 'user_statistics_event.dart';
part 'user_statistics_state.dart';

Map<int, List<UserStatistic>> _watchTimeStatsListCacheMap = {};
Map<int, List<UserStatistic>> _playerStatsListCacheMap = {};

class UserStatisticsBloc
    extends Bloc<UserStatisticsEvent, UserStatisticsState> {
  final GetUserWatchTimeStats getUserWatchTimeStats;
  final GetUserPlayerStats getUserPlayerStats;
  final Logging logging;

  UserStatisticsBloc({
    @required this.getUserWatchTimeStats,
    @required this.getUserPlayerStats,
    @required this.logging,
  }) : super(UserStatisticsInitial());

  @override
  Stream<UserStatisticsState> mapEventToState(
    UserStatisticsEvent event,
  ) async* {
    if (event is UserStatisticsFetch) {
      yield UserStatisticsInProgress();

      if (_watchTimeStatsListCacheMap.containsKey(event.userId) &&
          _playerStatsListCacheMap.containsKey(event.userId) &&
          _watchTimeStatsListCacheMap[event.userId].isNotEmpty) {
        yield UserStatisticsSuccess(
          watchTimeStatsList: _watchTimeStatsListCacheMap[event.userId],
          playerStatsList: _playerStatsListCacheMap[event.userId],
        );
      } else {
        // Build out stat lists
        List<UserStatistic> watchTimeStatsList = [];
        bool watchTimeStatsFailed = false;
        List<UserStatistic> playerStatsList = [];
        bool playerStatsFailed = false;
        Failure statFailure;

        final failureOrUserWatchTimeStats = await getUserWatchTimeStats(
          tautulliId: event.tautulliId,
          userId: event.userId,
          settingsBloc: event.settingsBloc,
        );

        failureOrUserWatchTimeStats.fold(
          (failure) {
            watchTimeStatsFailed = true;
            statFailure = failure;
            logging.error(
                'History: Failed to load user watch time stats for user ID ${event.userId}');
          },
          (list) {
            watchTimeStatsList = list;
          },
        );

        final failureOrUserPlayerStats = await getUserPlayerStats(
          tautulliId: event.tautulliId,
          userId: event.userId,
          settingsBloc: event.settingsBloc,
        );

        failureOrUserPlayerStats.fold(
          (failure) {
            statFailure = failure;
            playerStatsFailed = true;
            logging.error(
                'History: Failed to load user player stats for user ID ${event.userId}');
          },
          (list) {
            playerStatsList = list;
          },
        );

        if (watchTimeStatsFailed && playerStatsFailed) {
          // Yield UserStatisticsFailure if both stat fetches fail
          yield UserStatisticsFailure(
            failure: statFailure,
            message: FailureMapperHelper.mapFailureToMessage(statFailure),
            suggestion: FailureMapperHelper.mapFailureToSuggestion(statFailure),
          );
        } else {
          _watchTimeStatsListCacheMap[event.userId] = watchTimeStatsList;
          _playerStatsListCacheMap[event.userId] = playerStatsList;

          yield UserStatisticsSuccess(
            watchTimeStatsList: watchTimeStatsList,
            playerStatsList: playerStatsList,
          );
        }
      }
    }
  }
}

void clearCache() {
  _watchTimeStatsListCacheMap = {};
  _playerStatsListCacheMap = {};
}
