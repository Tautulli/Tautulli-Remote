// @dart=2.9

import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api/tautulli_api.dart' as tautulli_api;
import '../../../settings/presentation/bloc/settings_bloc.dart';

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
    @required SettingsBloc settingsBloc,
  });
}

class ImageUrlDataSourceImpl implements ImageUrlDataSource {
  final tautulli_api.PmsImageProxy apiPmsImageProxy;

  ImageUrlDataSourceImpl({
    @required this.apiPmsImageProxy,
    String img,
    int ratingKey,
    int width,
    int height,
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
    @required SettingsBloc settingsBloc,
  }) async {
    final String url = await apiPmsImageProxy(
      tautulliId: tautulliId,
      img: img,
      ratingKey: ratingKey,
      width: width ?? 300,
      height: height ?? 450,
      opacity: opacity,
      background: background,
      blur: blur,
      fallback: fallback,
      settingsBloc: settingsBloc,
    );

    return url;
  }
}
