import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/image_url_repository.dart';
import '../datasources/image_url_data_source.dart';

class ImageUrlRepositoryImpl implements ImageUrlRepository {
  final ImageUrlDataSource dataSource;
  final NetworkInfo networkInfo;

  ImageUrlRepositoryImpl({
    @required this.dataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, String>> getImage({
    @required String tautulliId,
    String img,
    int ratingKey,
    int width,
    int height,
    int opacity,
    int background,
    int blur,
    String fallback,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final String url = await dataSource.getImage(
          tautulliId: tautulliId,
          img: img,
          ratingKey: ratingKey,
          width: width,
          height: height,
          opacity: opacity,
          background: background,
          blur: blur,
          fallback: fallback,
        );
        return Right(url);
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
