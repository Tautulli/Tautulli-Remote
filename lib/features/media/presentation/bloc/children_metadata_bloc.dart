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

part 'children_metadata_event.dart';
part 'children_metadata_state.dart';

Map<String, List<MediaModel>> childrenCache = {};

class ChildrenMetadataBloc extends Bloc<ChildrenMetadataEvent, ChildrenMetadataState> {
  final Media media;
  final ImageUrl imageUrl;
  final Logging logging;

  ChildrenMetadataBloc({
    required this.media,
    required this.imageUrl,
    required this.logging,
  }) : super(const ChildrenMetadataState()) {
    on<ChildrenMetadataFetched>(_onChildrenMetadataFetched);
  }

  _onChildrenMetadataFetched(
    ChildrenMetadataFetched event,
    Emitter<ChildrenMetadataState> emit,
  ) async {
    final String cacheKey = '${event.server.tautulliId}:${event.ratingKey}';

    if (event.freshFetch) {
      emit(
        state.copyWith(
          status: BlocStatus.initial,
        ),
      );
      childrenCache.remove(cacheKey);
    }

    if (childrenCache.containsKey(cacheKey)) {
      return emit(
        state.copyWith(
          status: BlocStatus.success,
          children: childrenCache[cacheKey],
        ),
      );
    }

    final failureOrChildren = await media.getChildrenMetadata(
      tautulliId: event.server.tautulliId,
      ratingKey: event.ratingKey,
    );

    await failureOrChildren.fold(
      (failure) async {
        logging.error('Metadata :: Failed to fetch children metadata for ${event.ratingKey} [$failure]');

        return emit(
          state.copyWith(
            status: BlocStatus.failure,
            failure: failure,
            message: FailureHelper.mapFailureToMessage(failure),
            suggestion: FailureHelper.mapFailureToSuggestion(failure),
          ),
        );
      },
      (children) async {
        event.settingsBloc.add(
          SettingsUpdatePrimaryActive(
            tautulliId: event.server.tautulliId,
            primaryActive: children.value2,
          ),
        );

        // Add posters to children media models
        List<MediaModel> childrenWithUris = await _mediaModelsWithImageUris(
          tautulliId: event.server.tautulliId,
          children: children.value1,
          settingsBloc: event.settingsBloc,
        );

        childrenCache[cacheKey] = childrenWithUris;

        return emit(
          state.copyWith(
            status: BlocStatus.success,
            children: childrenWithUris,
          ),
        );
      },
    );
  }

  Future<List<MediaModel>> _mediaModelsWithImageUris({
    required String tautulliId,
    required List<MediaModel> children,
    required SettingsBloc settingsBloc,
  }) async {
    List<MediaModel> childrenWithImages = [];

    for (MediaModel child in children) {
      Uri? imageUri;
      Uri? parentImageUri;
      Uri? grandparentImageUri;

      final failureOrImageUrl = await imageUrl.getImageUrl(
        tautulliId: tautulliId,
        img: child.thumb,
        ratingKey: child.ratingKey,
      );

      final failureOrParentImageUrl = await imageUrl.getImageUrl(
        tautulliId: tautulliId,
        img: child.parentThumb,
        ratingKey: child.parentRatingKey,
      );

      final failureOrGrandparentImageUrl = await imageUrl.getImageUrl(
        tautulliId: tautulliId,
        img: child.grandparentThumb,
        ratingKey: child.grandparentRatingKey,
      );

      await failureOrImageUrl.fold(
        (failure) async {
          logging.error(
            'Metadata :: Failed to fetch image url for ${child.title} [$failure]',
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
            'Metadata :: Failed to fetch parent image url for ${child.title} [$failure]',
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
            'Metadata :: Failed to fetch grandparent image url for ${child.title} [$failure]',
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

      childrenWithImages.add(
        child.copyWith(
          imageUri: imageUri,
          parentImageUri: parentImageUri,
          grandparentImageUri: grandparentImageUri,
        ),
      );
    }

    return childrenWithImages;
  }
}
