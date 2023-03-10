import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/types/image_fallback.dart';

abstract class ImageUrlRepository {
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
  });
}
