import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/network_info/network_info.dart';
import '../../../../core/types/image_fallback.dart';
import '../../domain/repositories/image_url_repository.dart';
import '../datasources/image_url_data_source.dart';

class ImageUrlRepositoryImpl implements ImageUrlRepository {
  final ImageUrlDataSource dataSource;
  final NetworkInfo networkInfo;

  ImageUrlRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Tuple2<Uri, bool>>> call({
    required String tautulliId,
    String? img,
    int? ratingKey,
    int? width,
    int? height,
    int? opacity,
    int? background,
    int? blur,
    String? imgFormat,
    ImageFallback? imageFallback,
    bool? refresh,
    bool? returnHash,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource(
          tautulliId: tautulliId,
          img: img,
          ratingKey: ratingKey,
          width: width,
          height: height,
          opacity: opacity,
          background: background,
          blur: blur,
          imgFormat: imgFormat,
          imageFallback: imageFallback,
          refresh: refresh,
          returnHash: returnHash,
        );

        return Right(result);
      } catch (e) {
        final failure = FailureHelper.castToFailure(e);
        return Left(failure);
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
