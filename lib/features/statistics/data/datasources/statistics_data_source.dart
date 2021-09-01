// @dart=2.9

import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api/tautulli_api.dart' as tautulli_api;
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/statistics.dart';
import '../models/statistics_model.dart';

abstract class StatisticsDataSource {
  Future<Map<String, List<Statistics>>> getStatistics({
    @required String tautulliId,
    int grouping,
    int timeRange,
    String statsType,
    int statsStart,
    int statsCount,
    String statId,
    @required SettingsBloc settingsBloc,
  });
}

class StatisticsDataSourceImpl implements StatisticsDataSource {
  final tautulli_api.GetHomeStats apiGetHomeStats;

  StatisticsDataSourceImpl({@required this.apiGetHomeStats});

  @override
  Future<Map<String, List<Statistics>>> getStatistics({
    @required String tautulliId,
    int grouping,
    int timeRange,
    String statsType,
    int statsStart,
    int statsCount,
    String statId,
    @required SettingsBloc settingsBloc,
  }) async {
    final statisticsJson = await apiGetHomeStats(
      tautulliId: tautulliId,
      grouping: grouping,
      timeRange: timeRange,
      statsType: statsType,
      statsStart: statsStart,
      statsCount: statsCount,
      statId: statId,
      settingsBloc: settingsBloc,
    );

    Map<String, List<Statistics>> statisticsMap = {};

    if (statId == null) {
      statisticsJson['response']['data'].forEach((statistic) {
        statisticsMap[statistic['stat_id']] = [];
        statistic['rows'].forEach((item) {
          statisticsMap[statistic['stat_id']].add(
            StatisticsModel.fromJson(
              statId: statistic['stat_id'],
              json: item,
            ),
          );
        });
      });
    } else {
      statisticsMap[statId] = [];
      statisticsJson['response']['data']['rows'].forEach((item) {
        statisticsMap[statId].add(
          StatisticsModel.fromJson(
            statId: statId,
            json: item,
          ),
        );
      });
    }

    return statisticsMap;
  }
}
