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
  final GetPlaysByGraphType getPlaysByGraphTypeApi;

  GraphsDataSourceImpl({
    required this.getConcurrentStreamsByStreamTypeApi,
    required this.getPlaysByGraphTypeApi,
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
    final result = await getPlaysByGraphTypeApi(
      tautulliId: tautulliId,
      cmd: 'get_plays_by_date',
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
    final result = await getPlaysByGraphTypeApi(
      tautulliId: tautulliId,
      cmd: 'get_plays_by_dayofweek',
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
    final result = await getPlaysByGraphTypeApi(
      tautulliId: tautulliId,
      cmd: 'get_plays_by_hourofday',
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
    final result = await getPlaysByGraphTypeApi(
      tautulliId: tautulliId,
      cmd: 'get_plays_by_source_resolution',
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
    final result = await getPlaysByGraphTypeApi(
      tautulliId: tautulliId,
      cmd: 'get_plays_by_stream_resolution',
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
    final result = await getPlaysByGraphTypeApi(
      tautulliId: tautulliId,
      cmd: 'get_plays_by_stream_type',
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
    final result = await getPlaysByGraphTypeApi(
      tautulliId: tautulliId,
      cmd: 'get_plays_by_top_10_platforms',
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
    final result = await getPlaysByGraphTypeApi(
      tautulliId: tautulliId,
      cmd: 'get_plays_per_month',
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
    final result = await getPlaysByGraphTypeApi(
      tautulliId: tautulliId,
      cmd: 'get_plays_by_top_10_users',
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
    final result = await getPlaysByGraphTypeApi(
      tautulliId: tautulliId,
      cmd: 'get_stream_type_by_top_10_platforms',
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
    final result = await getPlaysByGraphTypeApi(
      tautulliId: tautulliId,
      cmd: 'get_stream_type_by_top_10_users',
      yAxis: yAxis,
      timeRange: timeRange,
      userId: userId,
      grouping: grouping,
    );

    final GraphDataModel graphDataModel = GraphDataModel.fromJson(result.value1['response']['data']);

    return Tuple2(graphDataModel, result.value2);
  }
}
