import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/activity.dart';
import '../../domain/repositories/activity_repository.dart';
import '../datasources/activity_data_source.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityDataSource dataSource;
  final NetworkInfo networkInfo;

  ActivityRepositoryImpl({
    @required this.dataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ActivityItem>>> getActivity() async {
    if (await networkInfo.isConnected) {
      try {
        final activity = await dataSource.getActivity();
        return Right(activity);
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
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
