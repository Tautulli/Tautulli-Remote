import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/geo_ip.dart';
import '../../domain/repositories/geo_ip_repository.dart';
import '../datasources/geo_ip_data_source.dart';

class GeoIpRepositoryImpl implements GeoIpRepository {
  final GeoIpDataSource dataSource;
  final NetworkInfo networkInfo;

  GeoIpRepositoryImpl({
    @required this.dataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, GeoIpItem>> getGeoIp({
    @required String tautulliId,
    @required String ipAddress,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final geoIpItem = await dataSource.getGeoIp(
          tautulliId: tautulliId,
          ipAddress: ipAddress,
        );
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
      } on TimeoutException {
        return Left(TimeoutFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
