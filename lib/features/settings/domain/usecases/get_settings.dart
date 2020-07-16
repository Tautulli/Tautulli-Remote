import 'package:meta/meta.dart';

import '../../data/models/settings_model.dart';
import '../repositories/settings_repository.dart';

class GetSettings {
  final SettingsRepository repository;

  GetSettings({@required this.repository});

  Future<String> connectionAddress() async {
    return await repository.getConnectionAddress();
  }

  Future<String> deviceToken() async {
    return await repository.getDeviceToken();
  }

  Future<SettingsModel> load() async {
    return await repository.load();
  }
}