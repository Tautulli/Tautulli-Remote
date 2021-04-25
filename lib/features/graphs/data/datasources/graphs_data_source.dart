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

  Future<GraphData> getPlaysByHourOfDay({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  });

  Future<GraphData> getPlaysBySourceResolution({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  });

  Future<GraphData> getPlaysByStreamType({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  });

  Future<GraphData> getPlaysByTop10Platforms({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  });

  Future<GraphData> getPlaysByTop10Users({
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
  final tautulli_api.GetPlaysByHourOfDay apiGetPlaysByHourOfDay;
  final tautulli_api.GetPlaysBySourceResolution apiGetPlaysBySourceResolution;
  final tautulli_api.GetPlaysByStreamType apiGetPlaysByStreamType;
  final tautulli_api.GetPlaysByTop10Platforms apiGetPlaysByTop10Platforms;
  final tautulli_api.GetPlaysByTop10Users apiGetPlaysByTop10Users;

  GraphsDataSourceImpl({
    @required this.apiGetPlaysByDate,
    @required this.apiGetPlaysByDayOfWeek,
    @required this.apiGetPlaysByHourOfDay,
    @required this.apiGetPlaysBySourceResolution,
    @required this.apiGetPlaysByStreamType,
    @required this.apiGetPlaysByTop10Platforms,
    @required this.apiGetPlaysByTop10Users,
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

  @override
  Future<GraphData> getPlaysByHourOfDay({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  }) async {
    final playsByHourOfDayJson = await apiGetPlaysByHourOfDay(
      tautulliId: tautulliId,
      timeRange: timeRange,
      yAxis: yAxis,
      userId: userId,
      grouping: grouping,
      settingsBloc: settingsBloc,
    );

    List<String> categories = List<String>.from(
      playsByHourOfDayJson['response']['data']['categories'],
    );
    List<SeriesData> seriesDataList = [];
    playsByHourOfDayJson['response']['data']['series'].forEach((item) {
      seriesDataList.add(SeriesDataModel.fromJson(item));
    });

    return GraphDataModel(
      categories: categories,
      seriesDataList: seriesDataList,
    );
  }

  @override
  Future<GraphData> getPlaysBySourceResolution({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  }) async {
    final playsBySourceResolutionJson = await apiGetPlaysBySourceResolution(
      tautulliId: tautulliId,
      timeRange: timeRange,
      yAxis: yAxis,
      userId: userId,
      grouping: grouping,
      settingsBloc: settingsBloc,
    );

    List<String> categories = List<String>.from(
      playsBySourceResolutionJson['response']['data']['categories'],
    );
    List<SeriesData> seriesDataList = [];
    playsBySourceResolutionJson['response']['data']['series'].forEach((item) {
      seriesDataList.add(SeriesDataModel.fromJson(item));
    });

    return GraphDataModel(
      categories: categories,
      seriesDataList: seriesDataList,
    );
  }

  @override
  Future<GraphData> getPlaysByStreamType({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  }) async {
    final playsByStreamTypeJson = await apiGetPlaysByStreamType(
      tautulliId: tautulliId,
      timeRange: timeRange,
      yAxis: yAxis,
      userId: userId,
      grouping: grouping,
      settingsBloc: settingsBloc,
    );

    List<String> categories = List<String>.from(
      playsByStreamTypeJson['response']['data']['categories'],
    );
    List<SeriesData> seriesDataList = [];
    playsByStreamTypeJson['response']['data']['series'].forEach((item) {
      seriesDataList.add(SeriesDataModel.fromJson(item));
    });

    return GraphDataModel(
      categories: categories,
      seriesDataList: seriesDataList,
    );
  }

  @override
  Future<GraphData> getPlaysByTop10Platforms({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  }) async {
    final playsByTop10PlatformsJson = await apiGetPlaysByTop10Platforms(
      tautulliId: tautulliId,
      timeRange: timeRange,
      yAxis: yAxis,
      userId: userId,
      grouping: grouping,
      settingsBloc: settingsBloc,
    );

    List<String> categories = List<String>.from(
      playsByTop10PlatformsJson['response']['data']['categories'],
    );
    List<SeriesData> seriesDataList = [];
    playsByTop10PlatformsJson['response']['data']['series'].forEach((item) {
      seriesDataList.add(SeriesDataModel.fromJson(item));
    });

    return GraphDataModel(
      categories: categories,
      seriesDataList: seriesDataList,
    );
  }

  @override
  Future<GraphData> getPlaysByTop10Users({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  }) async {
    final playsByTop10UsersJson = await apiGetPlaysByTop10Users(
      tautulliId: tautulliId,
      timeRange: timeRange,
      yAxis: yAxis,
      userId: userId,
      grouping: grouping,
      settingsBloc: settingsBloc,
    );

    List<String> categories = List<String>.from(
      playsByTop10UsersJson['response']['data']['categories'],
    );
    List<SeriesData> seriesDataList = [];
    playsByTop10UsersJson['response']['data']['series'].forEach((item) {
      seriesDataList.add(SeriesDataModel.fromJson(item));
    });

    return GraphDataModel(
      categories: categories,
      seriesDataList: seriesDataList,
    );
  }
}
