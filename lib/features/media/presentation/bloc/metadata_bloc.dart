import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/media_model.dart';
import '../../domain/usecases/media.dart';

part 'metadata_event.dart';
part 'metadata_state.dart';

Map<String, MediaModel> metadataCache = {};

class MetadataBloc extends Bloc<MetadataEvent, MetadataState> {
  final Media media;
  final Logging logging;

  MetadataBloc({
    required this.media,
    required this.logging,
  }) : super(
          const MetadataState(),
        ) {
    on<MetadataFetched>(_onMetadataFetched);
  }

  _onMetadataFetched(
    MetadataFetched event,
    Emitter<MetadataState> emit,
  ) async {
    final String cacheKey = '${event.tautulliId}:${event.ratingKey}';

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
      tautulliId: event.tautulliId,
      ratingKey: event.ratingKey,
    );

    failureOrMetadata.fold(
      (failure) {
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
      (metadata) {
        event.settingsBloc.add(
          SettingsUpdatePrimaryActive(
            tautulliId: event.tautulliId,
            primaryActive: metadata.value2,
          ),
        );

        metadataCache[cacheKey] = metadata.value1;

        return emit(
          state.copyWith(
            status: BlocStatus.success,
            metadata: metadata.value1,
          ),
        );
      },
    );
  }
}
