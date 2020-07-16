import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/settings.dart';
import '../../domain/usecases/get_settings.dart';
import '../../domain/usecases/set_settings.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettings getSettings;
  final SetSettings setSettings;

  SettingsBloc({
    @required this.getSettings,
    @required this.setSettings,
  }) : super(SettingsInitial());

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is SettingsLoad) {
      yield SettingsLoadInProgress();
      final settings = await getSettings.load();
      yield SettingsLoadSuccess(settings: settings);
    }
    if (event is SettingsUpdateConnection) {
      // yield SettingsLoading();
      await setSettings.setConnection(event.value);
      final settings = await getSettings.load();
      yield SettingsLoadSuccess(settings: settings);
    }
    if (event is SettingsUpdateDeviceToken) {
      // yield SettingsLoading();
      await setSettings.setDeviceToken(event.value);
      final settings = await getSettings.load();
      yield SettingsLoadSuccess(settings: settings);
    }
  }
}
