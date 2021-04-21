import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api/tautulli_api.dart' as tautulli_api;
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/graph_data.dart';
import '../../domain/entities/series_data.dart';
import '../models/graph_data_model.dart';
import '../models/series_data_model.dart';

abstract class GraphsDataSource {
  Future<GraphData> getPlaysByDate({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  });

  Future<GraphData> getPlaysByDayOfWeek({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  });
}

class GraphsDataSourceImpl implements GraphsDataSource {
  final tautulli_api.GetPlaysByDate apiGetPlaysByDate;
  final tautulli_api.GetPlaysByDayOfWeek apiGetPlaysByDayOfWeek;

  GraphsDataSourceImpl({
    @required this.apiGetPlaysByDate,
    @required this.apiGetPlaysByDayOfWeek,
  });

  @override
  Future<GraphData> getPlaysByDate({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  }) async {
    final playsByDateJson = await apiGetPlaysByDate(
      tautulliId: tautulliId,
      timeRange: timeRange,
      yAxis: yAxis,
      userId: userId,
      grouping: grouping,
      settingsBloc: settingsBloc,
    );

    List<String> categories = List<String>.from(
      playsByDateJson['response']['data']['categories'],
    );
    List<SeriesData> seriesDataList = [];
    playsByDateJson['response']['data']['series'].forEach((item) {
      seriesDataList.add(SeriesDataModel.fromJson(item));
    });

    return GraphDataModel(
      categories: categories,
      seriesDataList: seriesDataList,
    );
  }

  @override
  Future<GraphData> getPlaysByDayOfWeek({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  }) async {
    final playsByDayOfWeekJson = await apiGetPlaysByDayOfWeek(
      tautulliId: tautulliId,
      timeRange: timeRange,
      yAxis: yAxis,
      userId: userId,
      grouping: grouping,
      settingsBloc: settingsBloc,
    );

    List<String> categories = List<String>.from(
      playsByDayOfWeekJson['response']['data']['categories'],
    );
    List<SeriesData> seriesDataList = [];
    playsByDayOfWeekJson['response']['data']['series'].forEach((item) {
      seriesDataList.add(SeriesDataModel.fromJson(item));
    });

    return GraphDataModel(
      categories: categories,
      seriesDataList: seriesDataList,
    );
  }
}
