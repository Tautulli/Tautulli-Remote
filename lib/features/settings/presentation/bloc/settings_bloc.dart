import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/manage_cache/manage_cache.dart';
import '../../data/models/app_settings_model.dart';
import '../../domain/usecases/settings.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final ManageCache manageCache;
  final Settings settings;

  SettingsBloc({
    required this.manageCache,
    required this.settings,
  }) : super(SettingsInitial()) {
    on<SettingsClearCache>((event, emit) => _onSettingsClearCache(event, emit));
    on<SettingsLoad>((event, emit) => _onSettingsLoad(event, emit));
    on<SettingsUpdateDoubleTapToExit>(
      (event, emit) => _onSettingsUpdateDoubleTapToExit(event, emit),
    );
    on<SettingsUpdateMaskSensitiveInfo>(
      (event, emit) => _onSettingsUpdateMaskSensitiveInfo(event, emit),
    );
    on<SettingsUpdateOneSignalBannerDismiss>(
      (event, emit) => _onSettingsUpdateOneSignalBannerDismiss(event, emit),
    );
    on<SettingsUpdateRefreshRate>(
      (event, emit) => _onSettingsUpdateRefreshRate(event, emit),
    );
    on<SettingsUpdateServerTimeout>(
      (event, emit) => _onSettingsUpdateServerTimeout(event, emit),
    );
  }

  void _onSettingsClearCache(
    SettingsClearCache event,
    Emitter<SettingsState> emit,
  ) async {
    manageCache.clearCache();
  }

  void _onSettingsLoad(
    SettingsLoad event,
    Emitter<SettingsState> emit,
  ) async {
    emit(
      SettingsInProgress(),
    );

    try {
      // Fetch settings
      final AppSettingsModel appSettings = AppSettingsModel(
        doubleTapToExit: await settings.getDoubleTapToExit(),
        maskSensitiveInfo: await settings.getMaskSensitiveInfo(),
        oneSignalBannerDismissed: await settings.getOneSignalBannerDismissed(),
        serverTimeout: await settings.getServerTimeout(),
        refreshRate: await settings.getRefreshRate(),
      );

      emit(
        SettingsSuccess(
          appSettings: appSettings,
        ),
      );
    } catch (e) {
      emit(
        SettingsFailure(),
      );
    }
  }

  void _onSettingsUpdateDoubleTapToExit(
    SettingsUpdateDoubleTapToExit event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.setDoubleTapToExit(event.doubleTapToExit);
    //TODO: Log change

    emit(
      SettingsSuccess(
        appSettings: currentState.appSettings.copyWith(
          doubleTapToExit: event.doubleTapToExit,
        ),
      ),
    );
  }

  void _onSettingsUpdateMaskSensitiveInfo(
    SettingsUpdateMaskSensitiveInfo event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.setMaskSensitiveInfo(event.maskSensitiveInfo);
    //TODO: Log change

    emit(
      SettingsSuccess(
        appSettings: currentState.appSettings.copyWith(
          maskSensitiveInfo: event.maskSensitiveInfo,
        ),
      ),
    );
  }

  void _onSettingsUpdateOneSignalBannerDismiss(
    SettingsUpdateOneSignalBannerDismiss event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.setOneSignalBannerDismissed(event.dismiss);
    //TODO: Log change

    emit(
      SettingsSuccess(
        appSettings: currentState.appSettings.copyWith(
          oneSignalBannerDismissed: event.dismiss,
        ),
      ),
    );
  }

  void _onSettingsUpdateRefreshRate(
    SettingsUpdateRefreshRate event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.setRefreshRate(event.refreshRate);
    //TODO: Log change

    emit(
      SettingsSuccess(
        appSettings: currentState.appSettings.copyWith(
          refreshRate: event.refreshRate,
        ),
      ),
    );
  }

  void _onSettingsUpdateServerTimeout(
    SettingsUpdateServerTimeout event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.setServerTimeout(event.timeout);
    //TODO: Log change

    emit(
      SettingsSuccess(
        appSettings: currentState.appSettings.copyWith(
          serverTimeout: event.timeout,
        ),
      ),
    );
  }
}
