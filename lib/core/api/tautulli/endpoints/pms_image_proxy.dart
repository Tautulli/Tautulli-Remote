import 'package:dartz/dartz.dart';

import '../../../types/tautulli_types.dart';
import '../connection_handler.dart';

abstract class PmsImageProxy {
  Future<Tuple2<dynamic, bool>> call({
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

class PmsImageProxyImpl implements PmsImageProxy {
  final ConnectionHandler connectionHandler;

  PmsImageProxyImpl(this.connectionHandler);

  @override
  Future<Tuple2<dynamic, bool>> call({
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
  }) {
    Map<String, dynamic> params = {};
    if (img != null) params['img'] = img;
    if (ratingKey != null) params['rating_key'] = ratingKey;
    if (width != null) params['width'] = width;
    if (height != null) params['height'] = height;
    if (opacity != null) params['opacity'] = opacity;
    if (background != null) params['background'] = background;
    if (blur != null) params['blur'] = blur;
    if (imgFormat != null) params['img_format'] = imgFormat;
    if (imageFallback != null) params['image_fallback'] = imageFallback;
    if (refresh != null) params['refresh'] = refresh;
    if (returnHash != null) params['return_hash'] = returnHash;

    final response = connectionHandler(
      tautulliId: tautulliId,
      cmd: 'pms_image_proxy',
      params: params,
    );

    return response;
  }
}
