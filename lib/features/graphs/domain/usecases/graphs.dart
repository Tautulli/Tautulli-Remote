import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/types/graph_y_axis.dart';
import '../../data/models/graph_data_model.dart';
import '../repositories/graphs_repository.dart';

class Graphs {
  final GraphsRepository repository;

  Graphs({required this.repository});

  /// Returns a `GraphDataModel` containing graph data for Plays by Date.
  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getPlaysByDate({
    required String tautulliId,
    required GraphYAxis yAxis,
    int? userId,
    bool? grouping,
  }) async {
    return await repository.getPlaysByDate(
      tautulliId: tautulliId,
      yAxis: yAxis,
      userId: userId,
      grouping: grouping,
    );
  }

  /// Returns a `GraphDataModel` containing graph data for Plays by Stream Type.
  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getPlaysByStreamType({
    required String tautulliId,
    required GraphYAxis yAxis,
    int? userId,
    bool? grouping,
  }) async {
    return await repository.getPlaysByStreamType(
      tautulliId: tautulliId,
      yAxis: yAxis,
      userId: userId,
      grouping: grouping,
    );
  }
}
