import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/library_user_stat_model.dart';
import '../../data/models/library_watch_time_stat_model.dart';
import '../../domain/usecases/libraries.dart';

part 'library_statistics_event.dart';
part 'library_statistics_state.dart';

Map<String, List<LibraryWatchTimeStatModel>> _watchTimeStatsCache = {};
Map<String, List<LibraryUserStatModel>> _userStatsCache = {};

class LibraryStatisticsBloc extends Bloc<LibraryStatisticsEvent, LibraryStatisticsState> {
  final Libraries libraries;
  final Logging logging;

  LibraryStatisticsBloc({
    required this.libraries,
    required this.logging,
  }) : super(const LibraryStatisticsState()) {
    on<LibraryStatisticsFetched>(_onLibraryStatisticsFetched);
  }

  void _onLibraryStatisticsFetched(
    LibraryStatisticsFetched event,
    Emitter<LibraryStatisticsState> emit,
  ) async {
    final String cacheKey = '${event.server.tautulliId}:${event.sectionId}';
    final bool userStatsCached = _userStatsCache.containsKey(cacheKey);
    final bool watchTimeStatsCached = _watchTimeStatsCache.containsKey(cacheKey);

    // Check cached data, if exists yield that data
    if (userStatsCached) {
      emit(
        state.copyWith(
          userStatsStatus: BlocStatus.success,
          userStatsList: _userStatsCache[cacheKey],
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
    if (event.freshFetch || (!watchTimeStatsCached || !userStatsCached)) {
      emit(
        state.copyWith(
          watchTimeStatsStatus: BlocStatus.initial,
          userStatsStatus: BlocStatus.initial,
        ),
      );

      // Fetch stats for user and yield as received
      final failureOrWatchTimeStats = await libraries.getLibraryWatchTimeStats(
        tautulliId: event.server.tautulliId,
        sectionId: event.sectionId,
      );

      final failureOrUserStats = await libraries.getLibraryUserStats(
        tautulliId: event.server.tautulliId,
        sectionId: event.sectionId,
      );

      _fetchAndEmitStats(
        event: event,
        emit: emit,
        failureOrWatchTimeStats: failureOrWatchTimeStats,
        failureOrUserStats: failureOrUserStats,
        cacheKey: cacheKey,
      );
    }
  }

  void _fetchAndEmitStats({
    required LibraryStatisticsFetched event,
    required Emitter<LibraryStatisticsState> emit,
    required Either<Failure, Tuple2<List<LibraryUserStatModel>, bool>> failureOrUserStats,
    required Either<Failure, Tuple2<List<LibraryWatchTimeStatModel>, bool>> failureOrWatchTimeStats,
    required String cacheKey,
  }) {
    List<LibraryUserStatModel>? userStatsList;
    BlocStatus? userStatsStatus;
    List<LibraryWatchTimeStatModel>? watchTimeStatsList;
    BlocStatus? watchTimeStatsStatus;
    Failure? failure;
    String? message;
    String? suggestion;

    failureOrUserStats.fold(
      (failure) {
        logging.error(
          'Libraries :: Failed to fetch user stats for library id: ${event.sectionId} [$failure]',
        );

        _userStatsCache.remove(cacheKey);
        userStatsStatus = BlocStatus.failure;
        userStatsList = [];
        failure = failure;
        message = FailureHelper.mapFailureToMessage(failure);
        suggestion = FailureHelper.mapFailureToSuggestion(failure);
      },
      (userStatList) {
        event.settingsBloc.add(
          SettingsUpdatePrimaryActive(
            tautulliId: event.server.tautulliId,
            primaryActive: userStatList.value2,
          ),
        );

        _userStatsCache[cacheKey] = userStatList.value1;
        userStatsStatus = BlocStatus.success;
        userStatsList = userStatList.value1;
      },
    );

    failureOrWatchTimeStats.fold(
      (failure) {
        logging.error(
          'Libraries :: Failed to fetch library stats for library id: ${event.sectionId} [$failure]',
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

    return emit(
      state.copyWith(
        userStatsStatus: userStatsStatus,
        userStatsList: userStatsList,
        watchTimeStatsStatus: watchTimeStatsStatus,
        watchTimeStatsList: watchTimeStatsList,
        failure: failure,
        message: message,
        suggestion: suggestion,
      ),
    );
  }
}
