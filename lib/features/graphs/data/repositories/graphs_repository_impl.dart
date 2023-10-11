import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/network_info/network_info.dart';
import '../../../../core/types/play_metric_type.dart';
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
  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getConcurrentStreamsByStreamType({
    required String tautulliId,
    required int timeRange,
    int? userId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getConcurrentStreamsByStreamType(
          tautulliId: tautulliId,
          timeRange: timeRange,
          userId: userId,
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
  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getPlaysByDate({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getPlaysByDate(
          tautulliId: tautulliId,
          yAxis: yAxis,
          timeRange: timeRange,
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
  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getPlaysByDayOfWeek({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getPlaysByDayOfWeek(
          tautulliId: tautulliId,
          yAxis: yAxis,
          timeRange: timeRange,
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
  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getPlaysByHourOfDay({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getPlaysByHourOfDay(
          tautulliId: tautulliId,
          yAxis: yAxis,
          timeRange: timeRange,
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
  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getPlaysBySourceResolution({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getPlaysBySourceResolution(
          tautulliId: tautulliId,
          yAxis: yAxis,
          timeRange: timeRange,
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
  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getPlaysByStreamResolution({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getPlaysByStreamResolution(
          tautulliId: tautulliId,
          yAxis: yAxis,
          timeRange: timeRange,
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
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getPlaysByStreamType(
          tautulliId: tautulliId,
          yAxis: yAxis,
          timeRange: timeRange,
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
  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getPlaysPerMonth({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getPlaysPerMonth(
          tautulliId: tautulliId,
          yAxis: yAxis,
          timeRange: timeRange,
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
  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getPlaysByTop10Platforms({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getPlaysByTop10Platforms(
          tautulliId: tautulliId,
          yAxis: yAxis,
          timeRange: timeRange,
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
  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getPlaysByTop10Users({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getPlaysByTop10Users(
          tautulliId: tautulliId,
          yAxis: yAxis,
          timeRange: timeRange,
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
  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getStreamTypeByTop10Platforms({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getStreamTypeByTop10Platforms(
          tautulliId: tautulliId,
          yAxis: yAxis,
          timeRange: timeRange,
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
  Future<Either<Failure, Tuple2<GraphDataModel, bool>>> getStreamTypeByTop10Users({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getStreamTypeByTop10Users(
          tautulliId: tautulliId,
          yAxis: yAxis,
          timeRange: timeRange,
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
