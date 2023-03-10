import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../domain/usecases/settings.dart';
import 'settings_bloc.dart';

part 'clear_tautulli_image_cache_event.dart';
part 'clear_tautulli_image_cache_state.dart';

class ClearTautulliImageCacheBloc
    extends Bloc<ClearTautulliImageCacheEvent, ClearTautulliImageCacheState> {
  final Settings settings;
  final Logging logging;

  ClearTautulliImageCacheBloc({
    required this.settings,
    required this.logging,
  }) : super(const ClearTautulliImageCacheState()) {
    on<ClearTautulliImageCacheStart>(_onClearTautulliImageCacheStart);
  }

  Future<void> _onClearTautulliImageCacheStart(
    ClearTautulliImageCacheStart event,
    Emitter<ClearTautulliImageCacheState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BlocStatus.initial,
      ),
    );

    final failureOrClearedTautulliImageCache = await settings.deleteImageCache(
      event.server.tautulliId,
    );

    failureOrClearedTautulliImageCache.fold(
      (failure) {
        logging.error(
          'Settings :: Failed to clear ${event.server.plexName} image cache [$failure]',
        );

        emit(
          state.copyWith(
            status: BlocStatus.failure,
            server: event.server,
          ),
        );
      },
      (result) {
        event.settingsBloc.add(
          SettingsUpdatePrimaryActive(
            tautulliId: event.server.tautulliId,
            primaryActive: result.value2,
          ),
        );

        logging.info(
          'Settings :: Cleared ${event.server.plexName} image cache',
        );

        return emit(
          state.copyWith(
            status: BlocStatus.success,
            server: event.server,
          ),
        );
      },
    );
  }
}
