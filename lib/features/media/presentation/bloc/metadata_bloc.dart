import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../image_url/domain/usecases/image_url.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/media_model.dart';
import '../../domain/usecases/media.dart';

part 'metadata_event.dart';
part 'metadata_state.dart';

Map<String, MediaModel> metadataCache = {};

class MetadataBloc extends Bloc<MetadataEvent, MetadataState> {
  final Media media;
  final ImageUrl imageUrl;
  final Logging logging;

  MetadataBloc({
    required this.media,
    required this.imageUrl,
    required this.logging,
  }) : super(const MetadataState()) {
    on<MetadataFetched>(_onMetadataFetched);
  }

  _onMetadataFetched(
    MetadataFetched event,
    Emitter<MetadataState> emit,
  ) async {
    final String cacheKey = '${event.server.tautulliId}:${event.ratingKey}';

    if (event.freshFetch) {
      emit(
        state.copyWith(
          status: BlocStatus.initial,
        ),
      );
      metadataCache.remove(cacheKey);
    }

    if (metadataCache.containsKey(cacheKey)) {
      return emit(
        state.copyWith(
          status: BlocStatus.success,
          metadata: metadataCache[cacheKey],
        ),
      );
    }

    final failureOrMetadata = await media.getMetadata(
      tautulliId: event.server.tautulliId,
      ratingKey: event.ratingKey,
    );

    await failureOrMetadata.fold(
      (failure) async {
        logging.error('Metadata :: Failed to fetch metadata for ${event.ratingKey} [$failure]');

        return emit(
          state.copyWith(
            status: BlocStatus.failure,
            failure: failure,
            message: FailureHelper.mapFailureToMessage(failure),
            suggestion: FailureHelper.mapFailureToSuggestion(failure),
          ),
        );
      },
      (metadata) async {
        event.settingsBloc.add(
          SettingsUpdatePrimaryActive(
            tautulliId: event.server.tautulliId,
            primaryActive: metadata.value2,
          ),
        );

        // Add posters to children media models
        MediaModel metadataWithUris = await _mediaModelWithImageUris(
          tautulliId: event.server.tautulliId,
          metadata: metadata.value1,
          settingsBloc: event.settingsBloc,
        );

        metadataCache[cacheKey] = metadataWithUris;

        return emit(
          state.copyWith(
            status: BlocStatus.success,
            metadata: metadataWithUris,
          ),
        );
      },
    );
  }

  Future<MediaModel> _mediaModelWithImageUris({
    required String tautulliId,
    required MediaModel metadata,
    required SettingsBloc settingsBloc,
  }) async {
    Uri? imageUri;
    Uri? parentImageUri;
    Uri? grandparentImageUri;

    final failureOrImageUrl = await imageUrl.getImageUrl(
      tautulliId: tautulliId,
      img: metadata.thumb,
      ratingKey: metadata.ratingKey,
    );

    final failureOrParentImageUrl = await imageUrl.getImageUrl(
      tautulliId: tautulliId,
      img: metadata.parentThumb,
      ratingKey: metadata.parentRatingKey,
    );

    final failureOrGrandparentImageUrl = await imageUrl.getImageUrl(
      tautulliId: tautulliId,
      img: metadata.grandparentThumb,
      ratingKey: metadata.grandparentRatingKey,
    );

    await failureOrImageUrl.fold(
      (failure) async {
        logging.error(
          'Metadata :: Failed to fetch image url for ${metadata.title} [$failure]',
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
          'Metadata :: Failed to fetch parent image url for ${metadata.title} [$failure]',
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
          'Metadata :: Failed to fetch grandparent image url for ${metadata.title} [$failure]',
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

    return metadata.copyWith(
      imageUri: imageUri,
      parentImageUri: parentImageUri,
      grandparentImageUri: grandparentImageUri,
    );
  }
}
