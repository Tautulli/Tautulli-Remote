import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api.dart';

abstract class ImageUrlDataSource {
  Future<String> getImage({
    @required String tautulliId,
    String img,
    int ratingKey,
    int width,
    int height,
    int opacity,
    int background,
    int blur,
    String fallback,
  });
}

class ImageUrlDataSourceImpl implements ImageUrlDataSource {
  final TautulliApi tautulliApi;

  ImageUrlDataSourceImpl({
    @required this.tautulliApi,
    String img,
    int ratingKey,
    int width,
    int height = 300,
    int opacity,
    int background,
    int blur,
    String fallback,
  });

  @override
  Future<String> getImage({
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
    final String url = await tautulliApi.pmsImageProxy(
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

    return url;
  }
}
