import '../../data/models/settings_model.dart';
import '../entities/settings.dart';

abstract class SettingsRepository {
  Future<String> getConnectionAddress();

  Future<void> setConnection(String value);

  Future<String> getDeviceToken();

  Future<bool> setDeviceToken(String value);

  Future<SettingsModel> load();

  Future<void> save(Settings settings);
}