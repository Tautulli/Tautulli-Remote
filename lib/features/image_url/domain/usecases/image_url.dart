import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/types/image_fallback.dart';
import '../repositories/image_url_repository.dart';

class ImageUrl {
  final ImageUrlRepository repository;

  ImageUrl({required this.repository});

  Future<Either<Failure, Tuple2<Uri, bool>>> getImageUrl({
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
    assert(img != null || ratingKey != null);

    return await repository(
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
  }
}
