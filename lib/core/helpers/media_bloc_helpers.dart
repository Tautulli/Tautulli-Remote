import '../../features/image_url/domain/usecases/image_url.dart';
import '../../features/logging/domain/usecases/logging.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../features/media/data/models/media_model.dart';

Future<MediaModel> mediaModelWithImageUris({
  required String tautulliId,
  required MediaModel media,
  required ImageUrl imageUrl,
  required SettingsBloc settingsBloc,
  required Logging logging,
}) async {
  Uri? imageUri;
  Uri? parentImageUri;
  Uri? grandparentImageUri;

  final failureOrImageUrl = await imageUrl.getImageUrl(
    tautulliId: tautulliId,
    img: media.thumb,
    ratingKey: media.ratingKey,
  );

  final failureOrParentImageUrl = await imageUrl.getImageUrl(
    tautulliId: tautulliId,
    img: media.parentThumb,
    ratingKey: media.parentRatingKey,
  );

  final failureOrGrandparentImageUrl = await imageUrl.getImageUrl(
    tautulliId: tautulliId,
    img: media.grandparentThumb,
    ratingKey: media.grandparentRatingKey,
  );

  await failureOrImageUrl.fold(
    (failure) async {
      logging.error(
        'Metadata :: Failed to fetch image url for ${media.title} [$failure]',
      );
    },
    (imageUriTuple) async {
      settingsBloc.add(
        SettingsUpdatePrimaryActive(
          tautulliId: tautulliId,
          primaryActive: imageUriTuple.value2,
        ),
      );

      imageUri = imageUriTuple.value1;
    },
  );

  await failureOrParentImageUrl.fold(
    (failure) async {
      logging.error(
        'Metadata :: Failed to fetch parent image url for ${media.title} [$failure]',
      );
    },
    (imageUriTuple) async {
      settingsBloc.add(
        SettingsUpdatePrimaryActive(
          tautulliId: tautulliId,
          primaryActive: imageUriTuple.value2,
        ),
      );

      parentImageUri = imageUriTuple.value1;
    },
  );

  await failureOrGrandparentImageUrl.fold(
    (failure) async {
      logging.error(
        'Metadata :: Failed to fetch grandparent image url for ${media.title} [$failure]',
      );
    },
    (imageUriTuple) async {
      settingsBloc.add(
        SettingsUpdatePrimaryActive(
          tautulliId: tautulliId,
          primaryActive: imageUriTuple.value2,
        ),
      );

      grandparentImageUri = imageUriTuple.value1;
    },
  );

  return media.copyWith(
    imageUri: imageUri,
    parentImageUri: parentImageUri,
    grandparentImageUri: grandparentImageUri,
  );
}
