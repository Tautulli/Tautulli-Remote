import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tautulli_remote_tdd/core/helpers/connection_address_helper.dart';

import '../../../../core/error/exception.dart';
import '../../domain/entities/settings.dart';
import '../models/settings_model.dart';

/// Provides various functions for storing and loading settings.
abstract class SettingsDataSource {
  /// Gets the connection address setting for communication with the Tautulli server.
  ///
  /// Example: `http://tautulli.com`.
  ///
  /// Throws [SettingsException] is no data is present.
  Future<String> getConnectionAddress();

  /// Saves the connection address setting to storage.
  Future<bool> setConnectionAddress(String value);

  /// Gets the connection protocol setting.
  ///
  /// Example: `http`.
  ///
  /// Throws [SettingsException] is no data is present.
  Future<String> getConnectionProtocol();

  /// Saves the connection protocol setting to storage.
  Future<bool> setConnectionProtocol(String value);

  /// Gets the connection domain setting.
  ///
  /// Example: `tautulli.com`.
  ///
  /// Throws [SettingsException] is no data is present.
  Future<String> getConnectionDomain();

  /// Saves the connection domain setting to storage.
  Future<bool> setConnectionDomain(String value);

  /// Gets the connection user setting if the connection address has basic auth.
  ///
  /// Example: `user` from `http://user:pass@tautulli.com`.
  ///
  /// Throws [SettingsException] is no data is present.
  Future<String> getConnectionUser();

  /// Saves the connection user setting to storage.
  Future<bool> setConnectionUser(String value);

  /// Gets the connection password settingif the connection address has basic auth.
  ///
  /// Example: `pass` from `http://user:pass@tautulli.com`.
  ///
  /// Throws [SettingsException] is no data is present.
  Future<String> getConnectionPassword();

  /// Saves the connection password setting to storage.
  Future<bool> setConnectionPassword(String value);

  /// Takes the provided connection address and saves all connection settings.
  ///
  /// [address, protocol, domain, user, password]
  Future<void> setConnection(String connectionAddress);

  /// Gets the device token setting for communication with the Tautulli server.
  ///
  /// Throws [SettingsException] is no data is present.
  Future<String> getDeviceToken();

  /// Saves the device token setting to storage.
  Future<bool> setDeviceToken(String value);

  /// Returns a [SettingsModel] with all the store settings.
  Future<SettingsModel> load();

  /// Takes in a [Settings] object and saves all the values to storage.
  Future<void> save(Settings settings);
}

const SETTINGS_CONNECTION_ADDRESS = 'SETTINGS_CONNECTION_ADDRESS';
const SETTINGS_CONNECTION_PROTOCOL = 'SETTINGS_CONNECTION_PROTOCOL';
const SETTINGS_CONNECTION_DOMAIN = 'SETTINGS_CONNECTION_DOMAIN';
const SETTINGS_CONNECTION_USER = 'SETTINGS_CONNECTION_USER';
const SETTINGS_CONNECTION_PASSWORD = 'SETTINGS_CONNECTION_PASSWORD';
const SETTINGS_DEVICE_TOKEN = 'SETTINGS_DEVICE_TOKEN';

class SettingsDataSourceImpl implements SettingsDataSource {
  final SharedPreferences sharedPreferences;
  final ConnectionAddressHelper connectionAddressHelper;

  SettingsDataSourceImpl({
    @required this.sharedPreferences,
    @required this.connectionAddressHelper,
  });

  @override
  Future<String> getConnectionAddress() {
    final value = sharedPreferences.getString(SETTINGS_CONNECTION_ADDRESS);
    return Future.value(value);
  }

  @override
  Future<bool> setConnectionAddress(String value) {
    return sharedPreferences.setString(
      SETTINGS_CONNECTION_ADDRESS,
      value.trim(),
    );
  }

  @override
  Future<String> getConnectionProtocol() {
    final value = sharedPreferences.getString(SETTINGS_CONNECTION_PROTOCOL);
    return Future.value(value);
  }

  @override
  Future<bool> setConnectionProtocol(String value) {
    if (value != null) {
      value = value.trim();
    }

    return sharedPreferences.setString(
      SETTINGS_CONNECTION_PROTOCOL,
      value,
    );
  }

  @override
  Future<String> getConnectionDomain() {
    final value = sharedPreferences.getString(SETTINGS_CONNECTION_DOMAIN);
    return Future.value(value);
  }

  @override
  Future<bool> setConnectionDomain(String value) {
    if (value != null) {
      value = value.trim();
    }

    return sharedPreferences.setString(
      SETTINGS_CONNECTION_DOMAIN,
      value,
    );
  }

  @override
  Future<String> getConnectionUser() {
    final value = sharedPreferences.getString(SETTINGS_CONNECTION_USER);
    return Future.value(value);
  }

  @override
  Future<bool> setConnectionUser(String value) {
    if (value != null) {
      value = value.trim();
    }

    return sharedPreferences.setString(
      SETTINGS_CONNECTION_USER,
      value,
    );
  }

  @override
  Future<String> getConnectionPassword() {
    final value = sharedPreferences.getString(SETTINGS_CONNECTION_PASSWORD);
    return Future.value(value);
  }

  @override
  Future<bool> setConnectionPassword(String value) {
    if (value != null) {
      value = value.trim();
    }
    return sharedPreferences.setString(
      SETTINGS_CONNECTION_PASSWORD,
      value,
    );
  }

  @override
  Future<void> setConnection(String connectionAddress) async {
    final connectionAddressMap =
        connectionAddressHelper.parse(connectionAddress);
    await setConnectionAddress(connectionAddress);
    await setConnectionProtocol(connectionAddressMap['protocol']);
    await setConnectionDomain(connectionAddressMap['domain']);
    await setConnectionUser(connectionAddressMap['user']);
    await setConnectionPassword(connectionAddressMap['password']);
  }

  @override
  Future<String> getDeviceToken() {
    final deviceToken = sharedPreferences.getString(SETTINGS_DEVICE_TOKEN);
    return Future.value(deviceToken);
  }

  @override
  Future<bool> setDeviceToken(String value) {
    if (value != null) {
      value = value.trim();
    }

    return sharedPreferences.setString(
      SETTINGS_DEVICE_TOKEN,
      value,
    );
  }

  @override
  Future<SettingsModel> load() async {
    return Future.value(
      SettingsModel(
        connectionAddress: await getConnectionAddress(),
        connectionProtocol: await getConnectionProtocol(),
        connectionDomain: await getConnectionDomain(),
        connectionUser: await getConnectionUser(),
        connectionPassword: await getConnectionPassword(),
        deviceToken: await getDeviceToken(),
      ),
    );
  }

  @override
  Future<void> save(Settings settings) async {
    await setConnection(settings.connectionAddress);
    await setDeviceToken(settings.deviceToken);
  }
}
