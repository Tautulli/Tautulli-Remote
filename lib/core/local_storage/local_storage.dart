import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorage {
  bool? getBool(String key);

  int? getInt(String key);

  String? getString(String key);

  List<String>? getStringList(String key);

  Future<bool> setBool(String key, bool value);

  Future<bool> setInt(String key, int value);

  Future<bool> setString(String key, String value);

  Future<bool> setStringList(String key, List<String> value);
}

class LocalStorageImpl implements LocalStorage {
  final SharedPreferences sharedPreferences;

  LocalStorageImpl(this.sharedPreferences);

  @override
  bool? getBool(String key) {
    return sharedPreferences.getBool(key);
  }

  @override
  int? getInt(String key) {
    return sharedPreferences.getInt(key);
  }

  @override
  String? getString(String key) {
    return sharedPreferences.getString(key);
  }

  @override
  List<String>? getStringList(String key) {
    return sharedPreferences.getStringList(key);
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    return await sharedPreferences.setBool(key, value);
  }

  @override
  Future<bool> setInt(String key, int value) async {
    return await sharedPreferences.setInt(key, value);
  }

  @override
  Future<bool> setString(String key, String value) async {
    return await sharedPreferences.setString(key, value);
  }

  @override
  Future<bool> setStringList(String key, List<String> value) async {
    return await sharedPreferences.setStringList(key, value);
  }
}
