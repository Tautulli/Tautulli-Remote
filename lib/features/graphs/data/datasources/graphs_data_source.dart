import 'package:dartz/dartz.dart';

import '../../../../core/api/tautulli/tautulli_api.dart';
import '../../../../core/types/play_metric_type.dart';
import '../models/graph_data_model.dart';

abstract class GraphsDataSource {
  Future<Tuple2<GraphDataModel, bool>> getConcurrentStreamsByStreamType({
    required String tautulliId,
    required int timeRange,
    int? userId,
  });

  Future<Tuple2<GraphDataModel, bool>> getPlaysByDate({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  });

  Future<Tuple2<GraphDataModel, bool>> getPlaysByDayOfWeek({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  });

  Future<Tuple2<GraphDataModel, bool>> getPlaysByHourOfDay({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  });

  Future<Tuple2<GraphDataModel, bool>> getPlaysBySourceResolution({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  });

  Future<Tuple2<GraphDataModel, bool>> getPlaysByStreamResolution({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  });

  Future<Tuple2<GraphDataModel, bool>> getPlaysByStreamType({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  });

  Future<Tuple2<GraphDataModel, bool>> getPlaysByTop10Platforms({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  });

  Future<Tuple2<GraphDataModel, bool>> getPlaysPerMonth({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  });

  Future<Tuple2<GraphDataModel, bool>> getPlaysByTop10Users({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  });

  Future<Tuple2<GraphDataModel, bool>> getStreamTypeByTop10Platforms({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  });

  Future<Tuple2<GraphDataModel, bool>> getStreamTypeByTop10Users({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  });
}

class GraphsDataSourceImpl implements GraphsDataSource {
  final GetConcurrentStreamsByStreamType getConcurrentStreamsByStreamTypeApi;
  final GetPlaysByDate getPlaysByDateApi;
  final GetPlaysByDayOfWeek getPlaysByDayOfWeekApi;
  final GetPlaysByHourOfDay getPlaysByHourOfDayApi;
  final GetPlaysBySourceResolution getPlaysBySourceResolutionApi;
  final GetPlaysByStreamResolution getPlaysByStreamResolutionApi;
  final GetPlaysByStreamType getPlaysByStreamTypeApi;
  final GetPlaysByTop10Platforms getPlaysByTop10PlatformsApi;
  final GetPlaysByTop10Users getPlaysByTop10UsersApi;
  final GetPlaysPerMonth getPlaysPerMonthApi;
  final GetStreamTypeByTop10Platforms getStreamTypeByTop10PlatformsApi;
  final GetStreamTypeByTop10Users getStreamTypeByTop10UsersApi;

  GraphsDataSourceImpl({
    required this.getConcurrentStreamsByStreamTypeApi,
    required this.getPlaysByDateApi,
    required this.getPlaysByDayOfWeekApi,
    required this.getPlaysByHourOfDayApi,
    required this.getPlaysBySourceResolutionApi,
    required this.getPlaysByStreamResolutionApi,
    required this.getPlaysByStreamTypeApi,
    required this.getPlaysByTop10PlatformsApi,
    required this.getPlaysByTop10UsersApi,
    required this.getPlaysPerMonthApi,
    required this.getStreamTypeByTop10PlatformsApi,
    required this.getStreamTypeByTop10UsersApi,
  });

  @override
  Future<Tuple2<GraphDataModel, bool>> getConcurrentStreamsByStreamType({
    required String tautulliId,
    required int timeRange,
    int? userId,
  }) async {
    final result = await getConcurrentStreamsByStreamTypeApi(
      tautulliId: tautulliId,
      timeRange: timeRange,
      userId: userId,
    );

    final GraphDataModel graphDataModel = GraphDataModel.fromJson(result.value1['response']['data']);

    return Tuple2(graphDataModel, result.value2);
  }

  @override
  Future<Tuple2<GraphDataModel, bool>> getPlaysByDate({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    final result = await getPlaysByDateApi(
      tautulliId: tautulliId,
      yAxis: yAxis,
      timeRange: timeRange,
      userId: userId,
      grouping: grouping,
    );

    final GraphDataModel graphDataModel = GraphDataModel.fromJson(result.value1['response']['data']);

    return Tuple2(graphDataModel, result.value2);
  }

  @override
  Future<Tuple2<GraphDataModel, bool>> getPlaysByDayOfWeek({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    final result = await getPlaysByDayOfWeekApi(
      tautulliId: tautulliId,
      yAxis: yAxis,
      timeRange: timeRange,
      userId: userId,
      grouping: grouping,
    );

    final GraphDataModel graphDataModel = GraphDataModel.fromJson(result.value1['response']['data']);

    return Tuple2(graphDataModel, result.value2);
  }

  @override
  Future<Tuple2<GraphDataModel, bool>> getPlaysByHourOfDay({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    final result = await getPlaysByHourOfDayApi(
      tautulliId: tautulliId,
      yAxis: yAxis,
      timeRange: timeRange,
      userId: userId,
      grouping: grouping,
    );

    final GraphDataModel graphDataModel = GraphDataModel.fromJson(result.value1['response']['data']);

    return Tuple2(graphDataModel, result.value2);
  }

  @override
  Future<Tuple2<GraphDataModel, bool>> getPlaysBySourceResolution({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    final result = await getPlaysBySourceResolutionApi(
      tautulliId: tautulliId,
      yAxis: yAxis,
      timeRange: timeRange,
      userId: userId,
      grouping: grouping,
    );

    final GraphDataModel graphDataModel = GraphDataModel.fromJson(result.value1['response']['data']);

    return Tuple2(graphDataModel, result.value2);
  }

  @override
  Future<Tuple2<GraphDataModel, bool>> getPlaysByStreamResolution({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    final result = await getPlaysByStreamResolutionApi(
      tautulliId: tautulliId,
      yAxis: yAxis,
      timeRange: timeRange,
      userId: userId,
      grouping: grouping,
    );

    final GraphDataModel graphDataModel = GraphDataModel.fromJson(result.value1['response']['data']);

    return Tuple2(graphDataModel, result.value2);
  }

  @override
  Future<Tuple2<GraphDataModel, bool>> getPlaysByStreamType({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    final result = await getPlaysByStreamTypeApi(
      tautulliId: tautulliId,
      yAxis: yAxis,
      timeRange: timeRange,
      userId: userId,
      grouping: grouping,
    );

    final GraphDataModel graphDataModel = GraphDataModel.fromJson(result.value1['response']['data']);

    return Tuple2(graphDataModel, result.value2);
  }

  @override
  Future<Tuple2<GraphDataModel, bool>> getPlaysPerMonth({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    final result = await getPlaysPerMonthApi(
      tautulliId: tautulliId,
      yAxis: yAxis,
      timeRange: timeRange,
      userId: userId,
      grouping: grouping,
    );

    final GraphDataModel graphDataModel = GraphDataModel.fromJson(result.value1['response']['data']);

    return Tuple2(graphDataModel, result.value2);
  }

  @override
  Future<Tuple2<GraphDataModel, bool>> getPlaysByTop10Platforms({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    final result = await getPlaysByTop10PlatformsApi(
      tautulliId: tautulliId,
      yAxis: yAxis,
      timeRange: timeRange,
      userId: userId,
      grouping: grouping,
    );

    final GraphDataModel graphDataModel = GraphDataModel.fromJson(result.value1['response']['data']);

    return Tuple2(graphDataModel, result.value2);
  }

  @override
  Future<Tuple2<GraphDataModel, bool>> getPlaysByTop10Users({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    final result = await getPlaysByTop10UsersApi(
      tautulliId: tautulliId,
      yAxis: yAxis,
      timeRange: timeRange,
      userId: userId,
      grouping: grouping,
    );

    final GraphDataModel graphDataModel = GraphDataModel.fromJson(result.value1['response']['data']);

    return Tuple2(graphDataModel, result.value2);
  }

  @override
  Future<Tuple2<GraphDataModel, bool>> getStreamTypeByTop10Platforms({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    final result = await getStreamTypeByTop10PlatformsApi(
      tautulliId: tautulliId,
      yAxis: yAxis,
      timeRange: timeRange,
      userId: userId,
      grouping: grouping,
    );

    final GraphDataModel graphDataModel = GraphDataModel.fromJson(result.value1['response']['data']);

    return Tuple2(graphDataModel, result.value2);
  }

  @override
  Future<Tuple2<GraphDataModel, bool>> getStreamTypeByTop10Users({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    final result = await getStreamTypeByTop10UsersApi(
      tautulliId: tautulliId,
      yAxis: yAxis,
      timeRange: timeRange,
      userId: userId,
      grouping: grouping,
    );

    final GraphDataModel graphDataModel = GraphDataModel.fromJson(result.value1['response']['data']);

    return Tuple2(graphDataModel, result.value2);
  }
}
