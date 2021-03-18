import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../../core/network/network_info.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
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
    @required SettingsBloc settingsBloc,
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
          settingsBloc: settingsBloc,
        );
        return Right(url);
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
