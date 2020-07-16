import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:tautulli_remote_tdd/core/error/exception.dart';
import 'package:tautulli_remote_tdd/core/error/failure.dart';
import 'package:tautulli_remote_tdd/core/network/network_info.dart';
import 'package:tautulli_remote_tdd/features/activity/data/datasources/geo_ip_data_source.dart';
import 'package:tautulli_remote_tdd/features/activity/domain/entities/geo_ip.dart';
import 'package:tautulli_remote_tdd/features/activity/domain/repositories/geo_ip_repository.dart';
import 'package:meta/meta.dart';

class GeoIpRepositoryImpl implements GeoIpRepository {
  final GeoIpDataSource dataSource;
  final NetworkInfo networkInfo;

  GeoIpRepositoryImpl({
    @required this.dataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, GeoIpItem>> getGeoIp(String ipAddress) async {
    if (await networkInfo.isConnected) {
      try {
        final geoIpItem = await dataSource.getGeoIp(ipAddress);
        return Right(geoIpItem);
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
