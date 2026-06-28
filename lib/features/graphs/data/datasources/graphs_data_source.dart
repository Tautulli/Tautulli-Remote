// ignore_for_file: use_null_aware_elements

import 'package:dartz/dartz.dart';

import '../../../../core/api/tautulli_connection_adapter.dart';
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
  final TautulliConnectionAdapter adapter;

  GraphsDataSourceImpl({required this.adapter});

  Future<Tuple2<GraphDataModel, bool>> _fetch(
    String tautulliId,
    String cmd,
    Map<String, dynamic> params,
  ) async {
    final result = await adapter.call(
      tautulliId: tautulliId,
      action: (client) => client.execute(cmd, params: params),
    );
    return Tuple2(GraphDataModel.fromJson(result.data['data']), result.primaryActive);
  }

  Map<String, dynamic> _yAxisParams(PlayMetricType yAxis, int timeRange, int? userId, bool? grouping) => {
        'y_axis': yAxis.value,
        'time_range': timeRange,
        if (userId != null) 'user_id': userId,
        if (grouping != null) 'grouping': grouping ? 1 : 0,
      };

  @override
  Future<Tuple2<GraphDataModel, bool>> getConcurrentStreamsByStreamType({
    required String tautulliId,
    required int timeRange,
    int? userId,
  }) =>
      _fetch(tautulliId, 'get_concurrent_streams_by_stream_type', {
        'time_range': timeRange,
        if (userId != null) 'user_id': userId,
      });

  @override
  Future<Tuple2<GraphDataModel, bool>> getPlaysByDate({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) =>
      _fetch(tautulliId, 'get_plays_by_date', _yAxisParams(yAxis, timeRange, userId, grouping));

  @override
  Future<Tuple2<GraphDataModel, bool>> getPlaysByDayOfWeek({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) =>
      _fetch(tautulliId, 'get_plays_by_dayofweek', _yAxisParams(yAxis, timeRange, userId, grouping));

  @override
  Future<Tuple2<GraphDataModel, bool>> getPlaysByHourOfDay({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) =>
      _fetch(tautulliId, 'get_plays_by_hourofday', _yAxisParams(yAxis, timeRange, userId, grouping));

  @override
  Future<Tuple2<GraphDataModel, bool>> getPlaysBySourceResolution({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) =>
      _fetch(
          tautulliId, 'get_plays_by_source_resolution', _yAxisParams(yAxis, timeRange, userId, grouping));

  @override
  Future<Tuple2<GraphDataModel, bool>> getPlaysByStreamResolution({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) =>
      _fetch(
          tautulliId, 'get_plays_by_stream_resolution', _yAxisParams(yAxis, timeRange, userId, grouping));

  @override
  Future<Tuple2<GraphDataModel, bool>> getPlaysByStreamType({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) =>
      _fetch(tautulliId, 'get_plays_by_stream_type', _yAxisParams(yAxis, timeRange, userId, grouping));

  @override
  Future<Tuple2<GraphDataModel, bool>> getPlaysByTop10Platforms({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) =>
      _fetch(
          tautulliId, 'get_plays_by_top_10_platforms', _yAxisParams(yAxis, timeRange, userId, grouping));

  @override
  Future<Tuple2<GraphDataModel, bool>> getPlaysPerMonth({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) =>
      _fetch(tautulliId, 'get_plays_per_month', _yAxisParams(yAxis, timeRange, userId, grouping));

  @override
  Future<Tuple2<GraphDataModel, bool>> getPlaysByTop10Users({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) =>
      _fetch(tautulliId, 'get_plays_by_top_10_users', _yAxisParams(yAxis, timeRange, userId, grouping));

  @override
  Future<Tuple2<GraphDataModel, bool>> getStreamTypeByTop10Platforms({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) =>
      _fetch(tautulliId, 'get_stream_type_by_top_10_platforms',
          _yAxisParams(yAxis, timeRange, userId, grouping));

  @override
  Future<Tuple2<GraphDataModel, bool>> getStreamTypeByTop10Users({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) =>
      _fetch(
          tautulliId, 'get_stream_type_by_top_10_users', _yAxisParams(yAxis, timeRange, userId, grouping));
}
