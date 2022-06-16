import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/network_info/network_info.dart';
import '../../../../core/types/graph_y_axis.dart';
import '../../domain/repositories/graphs_repository.dart';
import '../datasources/graphs_data_source.dart';
import '../models/graph_data_model.dart';

class GraphsRepositoryImpl implements GraphsRepository {
  final GraphsDataSource dataSource;
  final NetworkInfo networkInfo;

  GraphsRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getPlaysByDate({
    required String tautulliId,
    required GraphYAxis yAxis,
    int? userId,
    bool? grouping,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getPlaysByDate(
          tautulliId: tautulliId,
          yAxis: yAxis,
          userId: userId,
          grouping: grouping,
        );

        return Right(result);
      } catch (e) {
        final failure = FailureHelper.castToFailure(e);
        return Left(failure);
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getPlaysByStreamType({
    required String tautulliId,
    required GraphYAxis yAxis,
    int? userId,
    bool? grouping,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getPlaysByStreamType(
          tautulliId: tautulliId,
          yAxis: yAxis,
          userId: userId,
          grouping: grouping,
        );

        return Right(result);
      } catch (e) {
        final failure = FailureHelper.castToFailure(e);
        return Left(failure);
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
