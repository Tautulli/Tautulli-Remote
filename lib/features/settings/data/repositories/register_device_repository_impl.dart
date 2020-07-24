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
    @required final String connectionProtocol,
    @required final String connectionDomain,
    @required final String connectionUser,
    @required final String connectionPassword,
    @required final String deviceToken,
    final bool clearOnesignalId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource(
          connectionProtocol: connectionProtocol,
          connectionDomain: connectionDomain,
          connectionUser: connectionUser,
          connectionPassword: connectionPassword,
          deviceToken: deviceToken,
          clearOnesignalId: clearOnesignalId,
        );
        return Right(result);
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
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
