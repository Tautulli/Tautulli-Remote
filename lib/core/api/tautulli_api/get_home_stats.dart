// @dart=2.9

import 'package:meta/meta.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import 'connection_handler.dart';

abstract class GetHomeStats {
  Future<Map<String, dynamic>> call({
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

class GetHomeStatsImpl implements GetHomeStats {
  final ConnectionHandler connectionHandler;

  GetHomeStatsImpl({@required this.connectionHandler});

  @override
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    int grouping,
    int timeRange,
    String statsType,
    int statsStart,
    int statsCount,
    String statId,
    @required SettingsBloc settingsBloc,
  }) async {
    Map<String, String> params = {};

    if (grouping != null) {
      params['grouping'] = grouping.toString();
    }
    if (timeRange != null) {
      params['time_range'] = timeRange.toString();
    }
    if (statsType != null) {
      params['stats_type'] = statsType;
    }
    if (statsStart != null) {
      params['stats_start'] = statsStart.toString();
    }
    if (statsCount != null) {
      params['stats_count'] = statsCount.toString();
    }
    if (statId != null) {
      params['stat_id'] = statId;
    }

    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_home_stats',
      params: params,
      settingsBloc: settingsBloc,
    );

    return responseJson;
  }
}
