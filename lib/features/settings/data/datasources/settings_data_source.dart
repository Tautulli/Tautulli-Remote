import '../../../../core/local_storage/local_storage.dart';

abstract class SettingsDataSource {
  // Server Timeout
  Future<int> getServerTimeout();
  Future<bool> setServerTimeout(int value);
}

const serverTimeout = 'serverTimeout';

class SettingsDataSourceImpl implements SettingsDataSource {
  final LocalStorage localStorage;

  SettingsDataSourceImpl({required this.localStorage});

  // Server Timeout
  @override
  Future<int> getServerTimeout() async {
    return Future.value(localStorage.getInt(serverTimeout) ?? 15);
  }

  @override
  Future<bool> setServerTimeout(int value) {
    return localStorage.setInt(serverTimeout, value);
  }
}
