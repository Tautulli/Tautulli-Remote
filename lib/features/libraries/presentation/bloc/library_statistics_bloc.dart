import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/library_statistic.dart';
import '../../domain/usecases/get_library_user_stats.dart';
import '../../domain/usecases/get_library_watch_time_stats.dart';

part 'library_statistics_event.dart';
part 'library_statistics_state.dart';

Map<String, List<LibraryStatistic>> _watchTimeStatsListCacheMap = {};
Map<String, List<LibraryStatistic>> _userStatsListCacheMap = {};

class LibraryStatisticsBloc
    extends Bloc<LibraryStatisticsEvent, LibraryStatisticsState> {
  final GetLibraryWatchTimeStats getLibraryWatchTimeStats;
  final GetLibraryUserStats getLibraryUserStats;
  final Logging logging;

  LibraryStatisticsBloc({
    @required this.getLibraryWatchTimeStats,
    @required this.getLibraryUserStats,
    @required this.logging,
  }) : super(LibraryStatisticsInitial());

  @override
  Stream<LibraryStatisticsState> mapEventToState(
    LibraryStatisticsEvent event,
  ) async* {
    if (event is LibraryStatisticsFetch) {
      yield LibraryStatisticsInProgress();

      if (_watchTimeStatsListCacheMap
              .containsKey('${event.tautulliId}:${event.sectionId}') &&
          _userStatsListCacheMap
              .containsKey('${event.tautulliId}:${event.sectionId}') &&
          _watchTimeStatsListCacheMap['${event.tautulliId}:${event.sectionId}']
              .isNotEmpty) {
        yield LibraryStatisticsSuccess(
          watchTimeStatsList: _watchTimeStatsListCacheMap[
              '${event.tautulliId}:${event.sectionId}'],
          userStatsList:
              _userStatsListCacheMap['${event.tautulliId}:${event.sectionId}'],
        );
      } else {
        // Build out stat lists
        List<LibraryStatistic> watchTimeStatsList = [];
        bool watchTimeStatsFailed = false;
        List<LibraryStatistic> userStatsList = [];
        bool userStatsFailed = false;
        Failure statFailure;

        final failureOrLibraryWatchTimeStats = await getLibraryWatchTimeStats(
          tautulliId: event.tautulliId,
          sectionId: event.sectionId,
          settingsBloc: event.settingsBloc,
        );

        failureOrLibraryWatchTimeStats.fold(
          (failure) {
            watchTimeStatsFailed = true;
            statFailure = failure;
            logging.error(
              'Library Statistics: Failed to load watch time stats for section ID ${event.sectionId}',
            );
          },
          (list) {
            watchTimeStatsList = list;
          },
        );

        final failureOrLibraryUserStats = await getLibraryUserStats(
          tautulliId: event.tautulliId,
          sectionId: event.sectionId,
          settingsBloc: event.settingsBloc,
        );

        failureOrLibraryUserStats.fold(
          (failure) {
            statFailure = failure;
            userStatsFailed = true;
            logging.error(
              'Library Statistics: Failed to load user stats for section ID ${event.sectionId}',
            );
          },
          (list) {
            userStatsList = list;
          },
        );

        if (watchTimeStatsFailed && userStatsFailed) {
          // Yield UserStatisticsFailure if both stat fetches fail
          yield LibraryStatisticsFailure(
            failure: statFailure,
            message: FailureMapperHelper.mapFailureToMessage(statFailure),
            suggestion: FailureMapperHelper.mapFailureToSuggestion(statFailure),
          );
        } else {
          _watchTimeStatsListCacheMap[
              '${event.tautulliId}:${event.sectionId}'] = watchTimeStatsList;
          _userStatsListCacheMap['${event.tautulliId}:${event.sectionId}'] =
              userStatsList;

          yield LibraryStatisticsSuccess(
            watchTimeStatsList: watchTimeStatsList,
            userStatsList: userStatsList,
          );
        }
      }
    }
  }
}

void clearCache() {
  _watchTimeStatsListCacheMap = {};
  _userStatsListCacheMap = {};
}
