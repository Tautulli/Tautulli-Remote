import 'package:dartz/dartz.dart';

import '../../../../core/api/tautulli/tautulli_api.dart';
import '../../../../core/types/graph_y_axis.dart';
import '../models/graph_data_model.dart';

abstract class GraphsDataSource {
  Future<Tuple2<GraphDataModel, bool>> getPlaysByDate({
    required String tautulliId,
    required GraphYAxis yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  });

  Future<Tuple2<GraphDataModel, bool>> getPlaysByStreamType({
    required String tautulliId,
    required GraphYAxis yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  });
}

class GraphsDataSourceImpl implements GraphsDataSource {
  final GetPlaysByDate getPlaysByDateApi;
  final GetPlaysByStreamType getPlaysByStreamTypeApi;

  GraphsDataSourceImpl({
    required this.getPlaysByDateApi,
    required this.getPlaysByStreamTypeApi,
  });

  @override
  Future<Tuple2<GraphDataModel, bool>> getPlaysByDate({
    required String tautulliId,
    required GraphYAxis yAxis,
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

    final GraphDataModel graphDataModel =
        GraphDataModel.fromJson(result.value1['response']['data']);

    return Tuple2(graphDataModel, result.value2);
  }

  @override
  Future<Tuple2<GraphDataModel, bool>> getPlaysByStreamType({
    required String tautulliId,
    required GraphYAxis yAxis,
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

    final GraphDataModel graphDataModel =
        GraphDataModel.fromJson(result.value1['response']['data']);

    return Tuple2(graphDataModel, result.value2);
  }
}
