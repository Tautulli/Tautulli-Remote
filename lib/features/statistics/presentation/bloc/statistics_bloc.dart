import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../core/database/data/models/server_model.dart';
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

const throttleDuration = Duration(milliseconds: 100);
const count = 20;

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

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
    on<StatisticsFetched>(_onStatisticsFetched);
    on<StatisticsFetchMore>(
      _onStatisticsFetchMore,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  void _onStatisticsFetched(
    StatisticsFetched event,
    Emitter<StatisticsState> emit,
  ) async {
    if (event.server.id == null) {
      Failure failure = MissingServerFailure();

      return emit(
        state.copyWith(
          status: BlocStatus.failure,
          failure: failure,
          message: FailureHelper.mapFailureToMessage(failure),
          suggestion: FailureHelper.mapFailureToSuggestion(failure),
        ),
      );
    }

    final bool serverChange = tautulliIdCache != event.server.tautulliId;

    if (!statCache.containsKey(event.server.tautulliId)) {
      statCache[event.server.tautulliId] = [];
    }

    if (event.freshFetch || (tautulliIdCache != null && serverChange)) {
      emit(
        state.copyWith(
          status: BlocStatus.initial,
          statList: serverChange ? [] : null,
          hasReachedMaxMap: {},
        ),
      );
      statCache[event.server.tautulliId] = [];
      statsTypeCache = null;
      timeRangeCache = null;
      hasReachedMaxCache = {};
    }

    tautulliIdCache = event.server.tautulliId;
    statsTypeCache = event.statsType;
    timeRangeCache = event.timeRange;

    if (state.status == BlocStatus.initial) {
      // Prevent triggering initial fetch when navigating back to History page
      if (statCache[event.server.tautulliId]!.isNotEmpty) {
        return emit(
          state.copyWith(
            status: BlocStatus.success,
          ),
        );
      }

      final failureOrStatistics = await statistics.getStatistics(
        tautulliId: event.server.tautulliId,
        statsType: event.statsType,
        timeRange: event.timeRange,
      );

      await failureOrStatistics.fold(
        (failure) async {
          logging.error('Statistics :: Failed to fetch statistics [$failure]');

          return emit(
            state.copyWith(
              status: BlocStatus.failure,
              statList: event.freshFetch ? statCache[event.server.tautulliId] : state.statList,
              failure: failure,
              message: FailureHelper.mapFailureToMessage(failure),
              suggestion: FailureHelper.mapFailureToSuggestion(failure),
            ),
          );
        },
        (statistics) async {
          event.settingsBloc.add(
            SettingsUpdatePrimaryActive(
              tautulliId: event.server.tautulliId,
              primaryActive: statistics.value2,
            ),
          );

          // Add posters to statistic models
          List<StatisticModel> statListWithUris = await _statisticModelsWithPosterUris(
            statList: statistics.value1,
            settingsBloc: event.settingsBloc,
          );

          statCache[event.server.tautulliId] = statListWithUris;

          return emit(
            state.copyWith(
              status: BlocStatus.success,
              statList: statCache[event.server.tautulliId],
            ),
          );
        },
      );
    }
  }

  void _onStatisticsFetchMore(
    StatisticsFetchMore event,
    Emitter<StatisticsState> emit,
  ) async {
    if (hasReachedMaxCache.containsKey(event.statIdType) && hasReachedMaxCache[event.statIdType]!) return;

    emit(
      state.copyWith(
        status: BlocStatus.initial,
      ),
    );

    final failureOrStatistics = await statistics.getStatistics(
      tautulliId: tautulliIdCache!,
      statsType: statsTypeCache,
      timeRange: timeRangeCache,
      statId: event.statIdType,
      statsCount: count,
      statsStart: statCache[tautulliIdCache]!
          .firstWhere((statisticModel) => statisticModel.statIdType == event.statIdType)
          .stats
          .length,
    );

    await failureOrStatistics.fold(
      (failure) async {
        logging.error('Statistics :: Failed to fetch more statistics for ${event.statIdType} [$failure]');

        return emit(
          state.copyWith(
            status: BlocStatus.failure,
            statList: [...statCache[tautulliIdCache]!],
            failure: failure,
            message: FailureHelper.mapFailureToMessage(failure),
            suggestion: FailureHelper.mapFailureToSuggestion(failure),
          ),
        );
      },
      (statistics) async {
        event.settingsBloc.add(
          SettingsUpdatePrimaryActive(
            tautulliId: tautulliIdCache!,
            primaryActive: statistics.value2,
          ),
        );

        // Add posters to statistic models
        List<StatisticModel> statListWithUris = await _statisticModelsWithPosterUris(
          statList: statistics.value1,
          settingsBloc: event.settingsBloc,
        );

        // Get StatisticModel index in statCache
        final int index =
            statCache[tautulliIdCache]!.indexWhere((statisticModel) => statisticModel.statIdType == event.statIdType);

        // Get existing StatisticModel
        StatisticModel statModel = statCache[tautulliIdCache]![index];

        // Replace index with updated StatisticModel
        statCache[tautulliIdCache]![index] = statModel.copyWith(
          stats: statModel.stats + statListWithUris.first.stats,
        );

        hasReachedMaxCache[event.statIdType] = statListWithUris.first.stats.length < count;

        return emit(
          state.copyWith(
            status: BlocStatus.success,
            statList: [...statCache[tautulliIdCache]!],
            hasReachedMaxMap: Map<StatIdType, bool>.from(hasReachedMaxCache),
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
