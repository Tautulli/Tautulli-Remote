import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/types/play_metric_type.dart';
import '../../data/models/graph_data_model.dart';
import '../repositories/graphs_repository.dart';

class Graphs {
  final GraphsRepository repository;

  Graphs({required this.repository});

  /// Returns a `GraphDataModel` containing graph data for Concurrent Streams by Stream Type.
  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getConcurrentStreamsByStreamType({
    required String tautulliId,
    required int timeRange,
    int? userId,
  }) async {
    return await repository.getConcurrentStreamsByStreamType(
      tautulliId: tautulliId,
      timeRange: timeRange,
      userId: userId,
    );
  }

  /// Returns a `GraphDataModel` containing graph data for Plays by Date.
  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getPlaysByDate({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    return await repository.getPlaysByDate(
      tautulliId: tautulliId,
      yAxis: yAxis,
      timeRange: timeRange,
      userId: userId,
      grouping: grouping,
    );
  }

  /// Returns a `GraphDataModel` containing graph data for Plays by Day of Week.
  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getPlaysByDayOfWeek({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    return await repository.getPlaysByDayOfWeek(
      tautulliId: tautulliId,
      yAxis: yAxis,
      timeRange: timeRange,
      userId: userId,
      grouping: grouping,
    );
  }

  /// Returns a `GraphDataModel` containing graph data for Plays by Hour of Day.
  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getPlaysByHourOfDay({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    return await repository.getPlaysByHourOfDay(
      tautulliId: tautulliId,
      yAxis: yAxis,
      timeRange: timeRange,
      userId: userId,
      grouping: grouping,
    );
  }

  /// Returns a `GraphDataModel` containing graph data for Plays by Source
  /// Resolution.
  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getPlaysBySourceResolution({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    return await repository.getPlaysBySourceResolution(
      tautulliId: tautulliId,
      yAxis: yAxis,
      timeRange: timeRange,
      userId: userId,
      grouping: grouping,
    );
  }

  /// Returns a `GraphDataModel` containing graph data for Plays by Stream
  /// Resolution.
  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getPlaysByStreamResolution({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    return await repository.getPlaysByStreamResolution(
      tautulliId: tautulliId,
      yAxis: yAxis,
      timeRange: timeRange,
      userId: userId,
      grouping: grouping,
    );
  }

  /// Returns a `GraphDataModel` containing graph data for Plays by Stream Type.
  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getPlaysByStreamType({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    return await repository.getPlaysByStreamType(
      tautulliId: tautulliId,
      yAxis: yAxis,
      timeRange: timeRange,
      userId: userId,
      grouping: grouping,
    );
  }

  /// Returns a `GraphDataModel` containing graph data for Plays Per Month.
  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getPlaysPerMonth({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    return await repository.getPlaysPerMonth(
      tautulliId: tautulliId,
      yAxis: yAxis,
      timeRange: timeRange,
      userId: userId,
      grouping: grouping,
    );
  }

  /// Returns a `GraphDataModel` containing graph data for Plays by Top 10 Platforms.
  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getPlaysByTop10Platforms({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    return await repository.getPlaysByTop10Platforms(
      tautulliId: tautulliId,
      yAxis: yAxis,
      timeRange: timeRange,
      userId: userId,
      grouping: grouping,
    );
  }

  /// Returns a `GraphDataModel` containing graph data for Plays by Top 10 Users.
  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getPlaysByTop10Users({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    return await repository.getPlaysByTop10Users(
      tautulliId: tautulliId,
      yAxis: yAxis,
      timeRange: timeRange,
      userId: userId,
      grouping: grouping,
    );
  }

  /// Returns a `GraphDataModel` containing graph data for Stream Type by Top 10
  /// Platforms.
  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getStreamTypeByTop10Platforms({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    return await repository.getStreamTypeByTop10Platforms(
      tautulliId: tautulliId,
      yAxis: yAxis,
      timeRange: timeRange,
      userId: userId,
      grouping: grouping,
    );
  }

  /// Returns a `GraphDataModel` containing graph data for Stream Type by Top 10
  /// Users.
  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getStreamTypeByTop10Users({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    return await repository.getStreamTypeByTop10Users(
      tautulliId: tautulliId,
      yAxis: yAxis,
      timeRange: timeRange,
      userId: userId,
      grouping: grouping,
    );
  }
}
