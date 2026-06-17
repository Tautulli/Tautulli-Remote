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

part 'metadata_event.dart';
part 'metadata_state.dart';

Map<String, MediaModel> metadataCache = {};

class MetadataBloc extends Bloc<MetadataEvent, MetadataState> {
  final Media media;
  final ImageUrl imageUrl;
  final Logging logging;
  final SettingsBloc settingsBloc;

  MetadataBloc({
    required this.media,
    required this.imageUrl,
    required this.logging,
    required this.settingsBloc,
  }) : super(const MetadataState()) {
    on<MetadataFetched>(_onMetadataFetched);
  }

  Future<void> _onMetadataFetched(
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
        settingsBloc.add(
          SettingsUpdatePrimaryActive(
            tautulliId: event.server.tautulliId,
            primaryActive: metadata.value2,
          ),
        );

        // Add posters to media model
        MediaModel metadataWithUris = await mediaModelWithImageUris(
          tautulliId: event.server.tautulliId,
          media: metadata.value1,
          imageUrl: imageUrl,
          settingsBloc: settingsBloc,
          logging: logging,
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
}
