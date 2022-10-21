import 'package:dartz/dartz.dart';

import '../../../../core/api/tautulli/endpoints/pms_image_proxy.dart';
import '../../../../core/types/image_fallback.dart';

abstract class ImageUrlDataSource {
  Future<Tuple2<Uri, bool>> call({
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

class ImageUrlDataSourceImpl implements ImageUrlDataSource {
  final PmsImageProxy pmsImageProxy;

  ImageUrlDataSourceImpl({
    required this.pmsImageProxy,
  });

  @override
  Future<Tuple2<Uri, bool>> call({
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
    final result = await pmsImageProxy(
      tautulliId: tautulliId,
      img: img,
      ratingKey: ratingKey,
      width: width ?? 300,
      height: height ?? 450,
      opacity: opacity,
      background: background,
      blur: blur,
      imgFormat: imgFormat,
      imageFallback: imageFallback,
      refresh: refresh,
      returnHash: returnHash,
    );

    return Tuple2(result.value1, result.value2);
  }
}
