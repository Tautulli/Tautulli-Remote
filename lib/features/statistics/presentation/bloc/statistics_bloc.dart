import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../../core/types/tautulli_types.dart';
import '../../../image_url/domain/usecases/image_url.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/statistic_data_model.dart';
import '../../data/models/statistic_model.dart';
import '../../domain/usecases/statistics.dart';

part 'statistics_event.dart';
part 'statistics_state.dart';

String? tautulliIdCache;
Map<String, List<StatisticModel>> statCache = {};
Map<StatIdType, bool> hasReachedMaxCache = {};
PlayMetricType? statsTypeCache;
int? timeRangeCache;

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final Statistics statistics;
  final ImageUrl imageUrl;
  final Logging logging;

  StatisticsBloc({
    required this.statistics,
    required this.imageUrl,
    required this.logging,
  }) : super(
          StatisticsState(
            statList: tautulliIdCache != null ? statCache[tautulliIdCache]! : [],
            statsType: statsTypeCache ?? PlayMetricType.plays,
            timeRange: timeRangeCache ?? 30,
          ),
        ) {
    on<StatisticsFetched>(_onStatisticsEvent);
  }

  void _onStatisticsEvent(
    StatisticsFetched event,
    Emitter<StatisticsState> emit,
  ) async {
    final bool serverChange = tautulliIdCache != event.tautulliId;

    if (!statCache.containsKey(event.tautulliId)) {
      statCache[event.tautulliId] = [];
    }

    if (event.freshFetch || (tautulliIdCache != null && serverChange)) {
      emit(
        state.copyWith(
          status: BlocStatus.initial,
          statList: serverChange ? [] : null,
          // hasReachedMax: false,
        ),
      );
      statCache[event.tautulliId] = [];
      statsTypeCache = null;
      timeRangeCache = null;
      // hasReachedMaxCache = false;
    }

    tautulliIdCache = event.tautulliId;
    statsTypeCache = event.statsType;
    timeRangeCache = event.timeRange;

    // if (statCache[event.tautulliId]!.isNotEmpty) {
    //   return emit(
    //     state.copyWith(status: BlocStatus.success),
    //   );
    // }

    if (state.status == BlocStatus.initial) {
      // Prevent triggering initial fetch when navigating back to History page
      if (statCache[event.tautulliId]!.isNotEmpty) {
        return emit(
          state.copyWith(
            status: BlocStatus.success,
          ),
        );
      }

      final failureOrStatistics = await statistics.getStatistics(
        tautulliId: event.tautulliId,
        statsType: event.statsType,
        timeRange: event.timeRange,
      );

      return _emitFailureOrStatistics(
        event: event,
        emit: emit,
        failureOrStatistics: failureOrStatistics,
      );
    } else {
      print(event.statsType);
    }
  }

  void _emitFailureOrStatistics({
    required StatisticsFetched event,
    required Emitter<StatisticsState> emit,
    required Either<Failure, Tuple2<List<StatisticModel>, bool>> failureOrStatistics,
  }) async {
    await failureOrStatistics.fold(
      (failure) async {
        logging.error('Statistics :: Failed to fetch statistics [$failure]');

        return emit(
          state.copyWith(
            status: BlocStatus.failure,
            statList: event.freshFetch ? statCache[event.tautulliId] : state.statList,
            failure: failure,
            message: FailureHelper.mapFailureToMessage(failure),
            suggestion: FailureHelper.mapFailureToSuggestion(failure),
          ),
        );
      },
      (statistics) async {
        event.settingsBloc.add(
          SettingsUpdatePrimaryActive(
            tautulliId: event.tautulliId,
            primaryActive: statistics.value2,
          ),
        );

        // Add posters to history models
        List<StatisticModel> statListWithUris = await _statisticModelsWithPosterUris(
          statList: statistics.value1,
          settingsBloc: event.settingsBloc,
        );

        statCache[event.tautulliId] = statListWithUris;
        // historyCache[event.tautulliId] = historyCache[event.tautulliId]! + historyListWithUris;
        // hasReachedMaxCache = historyListWithUris.length < length;

        return emit(
          state.copyWith(
            status: BlocStatus.success,
            statList: statCache[event.tautulliId],
          ),
        );
      },
    );
  }

  Future<List<StatisticModel>> _statisticModelsWithPosterUris({
    required List<StatisticModel> statList,
    required SettingsBloc settingsBloc,
  }) async {
    List<StatisticModel> statisticModelsWithImages = [];

    for (StatisticModel stat in statList) {
      List<StatisticDataModel> statisticDataModelList = [];

      for (StatisticDataModel statData in stat.stats) {
        final int? ratingKey =
            statData.mediaType == MediaType.episode ? statData.grandparentRatingKey : statData.ratingKey;

        if ((statData.thumb == null && ratingKey == null)) {
          statisticDataModelList.add(statData);
        } else {
          final failureOrImageUrl = await imageUrl.getImageUrl(
            tautulliId: tautulliIdCache!,
            img: statData.thumb,
            ratingKey: ratingKey,
          );

          await failureOrImageUrl.fold(
            (failure) async {
              logging.error(
                'Statistics :: Failed to fetch image url [$failure]',
              );

              statisticDataModelList.add(statData);
            },
            (imageUri) async {
              settingsBloc.add(
                SettingsUpdatePrimaryActive(
                  tautulliId: tautulliIdCache!,
                  primaryActive: imageUri.value2,
                ),
              );

              statisticDataModelList.add(
                statData.copyWith(
                  posterUri: imageUri.value1,
                ),
              );
            },
          );
        }
      }

      statisticModelsWithImages.add(stat.copyWith(stats: statisticDataModelList));
    }

    return statisticModelsWithImages;
  }
}
