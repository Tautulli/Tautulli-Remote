import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';

abstract class ImageUrlRepository {
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
  });
}
