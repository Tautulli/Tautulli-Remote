import 'package:meta/meta.dart';

import '../../domain/entities/settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_data_source.dart';
import '../models/settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsDataSource dataSource;

  SettingsRepositoryImpl({@required this.dataSource});

  @override
  Future<String> getConnectionAddress() async {
    final url = await dataSource.getConnectionAddress();
    return url;
  }

  @override
  Future<void> setConnection(String value) {
    return dataSource.setConnection(value);
  }

  @override
  Future<String> getDeviceToken() async {
    final deviceToken = await dataSource.getDeviceToken();
    return deviceToken;
  }

  @override
  Future<bool> setDeviceToken(String value) {
    return dataSource.setDeviceToken(value);
  }

  @override
  Future<SettingsModel> load() {
    return Future.value(dataSource.load());
  }

  @override
  Future<void> save(Settings settings) {
    return dataSource.save(settings);
  }
}
