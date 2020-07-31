import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/register_device_repository.dart';
import '../datasources/register_device_data_source.dart';

class RegisterDeviceRepositoryImpl implements RegisterDeviceRepository {
  final RegisterDeviceDataSource dataSource;
  final NetworkInfo networkInfo;

  RegisterDeviceRepositoryImpl({
    @required this.dataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, Map>> call({
    @required String connectionProtocol,
    @required String connectionDomain,
    @required String connectionPath,
    @required String deviceToken,
    bool clearOnesignalId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource(
          connectionProtocol: connectionProtocol,
          connectionDomain: connectionDomain,
          connectionPath: connectionPath,
          deviceToken: deviceToken,
          clearOnesignalId: clearOnesignalId,
        );
        return Right(result);
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
