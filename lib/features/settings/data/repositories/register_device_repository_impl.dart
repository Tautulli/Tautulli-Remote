// @dart=2.9

import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/database/data/models/custom_header_model.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
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
    List<CustomHeaderModel> headers,
    bool trustCert,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource(
          connectionProtocol: connectionProtocol,
          connectionDomain: connectionDomain,
          connectionPath: connectionPath,
          deviceToken: deviceToken,
          headers: headers,
          trustCert: trustCert,
        );
        return Right(result);
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
