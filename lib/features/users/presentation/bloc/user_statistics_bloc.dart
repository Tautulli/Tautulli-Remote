import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/user_player_stat_model.dart';
import '../../data/models/user_watch_time_stat_model.dart';
import '../../domain/usecases/users.dart';

part 'user_statistics_event.dart';
part 'user_statistics_state.dart';

Map<String, List<UserPlayerStatModel>> _playerStatsCache = {};
Map<String, List<UserWatchTimeStatModel>> _watchTimeStatsCache = {};

class UserStatisticsBloc extends Bloc<UserStatisticsEvent, UserStatisticsState> {
  final Users users;
  final Logging logging;

  UserStatisticsBloc({
    required this.users,
    required this.logging,
  }) : super(const UserStatisticsState()) {
    on<UserStatisticsFetched>(_onUserStatisticsFetched);
  }

  _onUserStatisticsFetched(
    UserStatisticsFetched event,
    Emitter<UserStatisticsState> emit,
  ) async {
    final String cacheKey = '${event.server.tautulliId}:${event.userId}';
    final bool playerStatsCached = _playerStatsCache.containsKey(cacheKey);
    final bool watchTimeStatsCached = _watchTimeStatsCache.containsKey(cacheKey);

    // Check cached data, if exists yield that data
    if (playerStatsCached) {
      emit(
        state.copyWith(
          playerStatsStatus: BlocStatus.success,
          playerStatsList: _playerStatsCache[cacheKey],
        ),
      );
    }

    if (watchTimeStatsCached) {
      emit(
        state.copyWith(
          watchTimeStatsStatus: BlocStatus.success,
          watchTimeStatsList: _watchTimeStatsCache[cacheKey],
        ),
      );
    }

    // If fresh fetch or either stat isn't in cache fetch data from Tautulli
    if (event.freshFetch || (!watchTimeStatsCached || !playerStatsCached)) {
      emit(
        state.copyWith(
          watchTimeStatsStatus: BlocStatus.initial,
          playerStatsStatus: BlocStatus.initial,
        ),
      );

      // Fetch stats for user and yield as received
      final failureOrWatchTimeStats = await users.getWatchTimeStats(
        tautulliId: event.server.tautulliId,
        userId: event.userId,
      );

      final failureOrPlayerStats = await users.getPlayerStats(
        tautulliId: event.server.tautulliId,
        userId: event.userId,
      );

      _fetchAndEmitStats(
        event: event,
        emit: emit,
        failureOrWatchTimeStats: failureOrWatchTimeStats,
        failureOrPlayerStats: failureOrPlayerStats,
        cacheKey: cacheKey,
      );
    }
  }

  void _fetchAndEmitStats({
    required UserStatisticsFetched event,
    required Emitter<UserStatisticsState> emit,
    required Either<Failure, Tuple2<List<UserWatchTimeStatModel>, bool>> failureOrWatchTimeStats,
    required Either<Failure, Tuple2<List<UserPlayerStatModel>, bool>> failureOrPlayerStats,
    required String cacheKey,
  }) {
    List<UserWatchTimeStatModel>? watchTimeStatsList;
    BlocStatus? watchTimeStatsStatus;
    List<UserPlayerStatModel>? playerStatsList;
    BlocStatus? playerStatsStatus;
    Failure? failure;
    String? message;
    String? suggestion;

    failureOrWatchTimeStats.fold(
      (failure) {
        logging.error(
          'Users :: Failed to fetch global stats for user id: ${event.userId} [$failure]',
        );

        _watchTimeStatsCache.remove(cacheKey);
        watchTimeStatsStatus = BlocStatus.failure;
        watchTimeStatsList = [];
        failure = failure;
        message = FailureHelper.mapFailureToMessage(failure);
        suggestion = FailureHelper.mapFailureToSuggestion(failure);
      },
      (watchTimeStatList) {
        event.settingsBloc.add(
          SettingsUpdatePrimaryActive(
            tautulliId: event.server.tautulliId,
            primaryActive: watchTimeStatList.value2,
          ),
        );

        _watchTimeStatsCache[cacheKey] = watchTimeStatList.value1;
        watchTimeStatsStatus = BlocStatus.success;
        watchTimeStatsList = watchTimeStatList.value1;
      },
    );

    failureOrPlayerStats.fold(
      (failure) {
        logging.error(
          'Users :: Failed to fetch player stats for user id: ${event.userId} [$failure]',
        );

        _playerStatsCache.remove(cacheKey);
        playerStatsStatus = BlocStatus.failure;
        playerStatsList = [];
        failure = failure;
        message = FailureHelper.mapFailureToMessage(failure);
        suggestion = FailureHelper.mapFailureToSuggestion(failure);
      },
      (playerStatList) {
        event.settingsBloc.add(
          SettingsUpdatePrimaryActive(
            tautulliId: event.server.tautulliId,
            primaryActive: playerStatList.value2,
          ),
        );

        _playerStatsCache[cacheKey] = playerStatList.value1;
        playerStatsStatus = BlocStatus.success;
        playerStatsList = playerStatList.value1;
      },
    );

    return emit(
      state.copyWith(
        watchTimeStatsStatus: watchTimeStatsStatus,
        watchTimeStatsList: watchTimeStatsList,
        playerStatsStatus: playerStatsStatus,
        playerStatsList: playerStatsList,
        failure: failure,
        message: message,
        suggestion: suggestion,
      ),
    );
  }
}
