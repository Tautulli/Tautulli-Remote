import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/types/graph_y_axis.dart';
import '../../data/models/graph_data_model.dart';

abstract class GraphsRepository {
  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getPlaysByDate({
    required String tautulliId,
    required GraphYAxis yAxis,
    int? userId,
    bool? grouping,
  });

  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getPlaysByStreamType({
    required String tautulliId,
    required GraphYAxis yAxis,
    int? userId,
    bool? grouping,
  });
}
