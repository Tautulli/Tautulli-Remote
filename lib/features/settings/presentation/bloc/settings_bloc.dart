import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/app_settings_model.dart';
import '../../domain/usecases/settings.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final Settings settings;

  SettingsBloc({
    required this.settings,
  }) : super(SettingsInitial()) {
    on<SettingsLoad>((event, emit) => _onSettingsLoad(event, emit));
    on<SettingsUpdateServerTimeout>(
      (event, emit) => _onSettingsUpdateServerTimeout(event, emit),
    );
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
        serverTimeout: await settings.getServerTimeout(),
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

  void _onSettingsUpdateServerTimeout(
    SettingsUpdateServerTimeout event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    settings.setServerTimeout(event.timeout);
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
