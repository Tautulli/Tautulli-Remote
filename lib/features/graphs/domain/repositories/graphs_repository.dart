import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/types/graph_y_axis.dart';
import '../../data/models/graph_data_model.dart';

abstract class GraphsRepository {
  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getPlaysByDate({
    required String tautulliId,
    required GraphYAxis yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  });

  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getPlaysByDayOfWeek({
    required String tautulliId,
    required GraphYAxis yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  });

  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getPlaysByHourOfDay({
    required String tautulliId,
    required GraphYAxis yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  });

  Future<Either<Failure, Tuple2<GraphDataModel, bool>>>
      getPlaysBySourceResolution({
    required String tautulliId,
    required GraphYAxis yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  });

  Future<Either<Failure, Tuple2<GraphDataModel, bool>>>
      getPlaysByStreamResolution({
    required String tautulliId,
    required GraphYAxis yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  });

  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getPlaysByStreamType({
    required String tautulliId,
    required GraphYAxis yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  });

  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getPlaysPerMonth({
    required String tautulliId,
    required GraphYAxis yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  });

  Future<Either<Failure, Tuple2<GraphDataModel, bool>>>
      getPlaysByTop10Platforms({
    required String tautulliId,
    required GraphYAxis yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  });

  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getPlaysByTop10Users({
    required String tautulliId,
    required GraphYAxis yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  });

  Future<Either<Failure, Tuple2<GraphDataModel, bool>>>
      getStreamTypeByTop10Platforms({
    required String tautulliId,
    required GraphYAxis yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  });

  Future<Either<Failure, Tuple2<GraphDataModel, bool>>>
      getStreamTypeByTop10Users({
    required String tautulliId,
    required GraphYAxis yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  });
}
