// @dart=2.9

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../repositories/image_url_repository.dart';

class GetImageUrl {
  final ImageUrlRepository repository;

  GetImageUrl({
    @required this.repository,
  });

  Future<Either<Failure, String>> call({
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
    return await repository.getImage(
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
  }
}
