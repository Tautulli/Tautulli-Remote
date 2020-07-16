import 'package:meta/meta.dart';

import '../entities/settings.dart';
import '../repositories/settings_repository.dart';

class SetSettings {
  final SettingsRepository repository;

  SetSettings({@required this.repository});

  Future<void> setConnection(String value) {
    return repository.setConnection(value);
  }

  Future<bool> setDeviceToken(String value) {
    return repository.setDeviceToken(value);
  }

  Future<void> save(Settings settings) {
    return repository.save(settings);
  }
}