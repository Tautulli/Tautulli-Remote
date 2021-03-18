import 'package:meta/meta.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import 'connection_handler.dart';

/// Returns a constructed URL as a String for accessing an
/// image via the `pms_image_proxy` endpoint.
abstract class PmsImageProxy {
  Future<String> call({
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

class PmsImageProxyImpl implements PmsImageProxy {
  final ConnectionHandler connectionHandler;

  PmsImageProxyImpl({@required this.connectionHandler});

  @override
  Future<String> call({
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
    Map<String, String> params = {
      'height': '300',
    };

    if (img != null) {
      params['img'] = img;
    }
    if (ratingKey != null) {
      params['rating_key'] = ratingKey.toString();
    }
    if (width != null) {
      params['width'] = width.toString();
    }
    if (height != null) {
      params['height'] = height.toString();
    }
    if (opacity != null) {
      params['opacity'] = opacity.toString();
    }
    if (background != null) {
      params['background'] = background.toString();
    }
    if (blur != null) {
      params['blur'] = blur.toString();
    }
    if (fallback != null) {
      params['fallback'] = fallback;
    }

    final Uri uri = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'pms_image_proxy',
      params: params,
      settingsBloc: settingsBloc,
    );
    return uri.toString();
  }
}
