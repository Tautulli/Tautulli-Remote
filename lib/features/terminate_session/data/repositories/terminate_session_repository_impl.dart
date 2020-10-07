import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/terminate_session_repository.dart';
import '../datasources/terminate_session_data_source.dart';

class TerminateSessionRepositoryImpl implements TerminateSessionRepository {
  final TerminateSessionDataSource dataSource;
  final NetworkInfo networkInfo;

  TerminateSessionRepositoryImpl({
    @required this.dataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, bool>> call({
    @required String tautulliId,
    @required String sessionId,
    String message,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource(
          tautulliId: tautulliId,
          sessionId: sessionId,
          message: message,
        );

        if (result) {
          return Right(result);
        } else {
          return Left(TerminateFailure());
        }
      } catch (exception) {
        final Failure failure =
            FailureMapperHelper.mapExceptionToFailure(exception);
        return (Left(failure));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
