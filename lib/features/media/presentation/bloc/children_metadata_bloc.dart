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
import '../../../../core/helpers/media_bloc_helpers.dart';

part 'children_metadata_event.dart';
part 'children_metadata_state.dart';

Map<String, List<MediaModel>> childrenCache = {};

class ChildrenMetadataBloc extends Bloc<ChildrenMetadataEvent, ChildrenMetadataState> {
  final Media media;
  final ImageUrl imageUrl;
  final Logging logging;
  final SettingsBloc settingsBloc;

  ChildrenMetadataBloc({
    required this.media,
    required this.imageUrl,
    required this.logging,
    required this.settingsBloc,
  }) : super(const ChildrenMetadataState()) {
    on<ChildrenMetadataFetched>(_onChildrenMetadataFetched);
  }

  Future<void> _onChildrenMetadataFetched(
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
        settingsBloc.add(
          SettingsUpdatePrimaryActive(
            tautulliId: event.server.tautulliId,
            primaryActive: children.value2,
          ),
        );

        // Add posters to children media models
        List<MediaModel> childrenWithUris = [];
        for (MediaModel child in children.value1) {
          childrenWithUris.add(
            await mediaModelWithImageUris(
              tautulliId: event.server.tautulliId,
              media: child,
              imageUrl: imageUrl,
              settingsBloc: settingsBloc,
              logging: logging,
            ),
          );
        }

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
}
