import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
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
      } on SettingsException {
        return Left(SettingsFailure());
      } on ServerException {
        return Left(ServerFailure());
      } on SocketException {
        return Left(SocketFailure());
      } on TlsException {
        return Left(TlsFailure());
      } on FormatException {
        return Left(UrlFormatFailure());
      } on ArgumentError {
        return Left(UrlFormatFailure());
      } on TimeoutException {
        return Left(TimeoutFailure());
      } on JsonDecodeException {
        return Left(JsonDecodeFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
