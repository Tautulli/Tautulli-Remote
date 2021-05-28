import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../../../core/network/network_info.dart';

/// Containers getters and functions for various OneSignal data points.
abstract class OneSignalDataSource {
  /// Checks if `https://onesignal.com` is reachable.
  Future<bool> get isReachable;

  /// Indicates if the user is subscribed to OneSignal.
  Future<bool> get isSubscribed;

  /// Provides the OneSignal User ID (AKA playerID).
  ///
  /// Returns an empty string if an error is thrown.
  Future<String> get userId;

  /// Returns `true` if the user has granted consent to the OneSignal SDK.
  Future<bool> get hasConsented;

  /// Grants or revokes consent based on the provided boolean.
  Future<void> grantConsent(bool value);

  /// Disables or enables push notifications
  Future<void> disablePush(bool value);
}

class OneSignalDataSourceImpl implements OneSignalDataSource {
  final http.Client client;
  final NetworkInfo networkInfo;

  OneSignalDataSourceImpl({
    @required this.client,
    @required this.networkInfo,
  });

  @override
  Future<bool> get isReachable async {
    if (await networkInfo.isConnected) {
      final response = await client.get(Uri.parse('https://onesignal.com'));
      if (response.statusCode == 200) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> get isSubscribed async {
    try {
      final status = await OneSignal.shared.getDeviceState();
      final subscribed = status.subscribed;
      return subscribed;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String> get userId async {
    try {
      final status = await OneSignal.shared.getDeviceState();
      final userId = status.userId;
      return userId;
    } catch (_) {
      return '';
    }
  }

  @override
  Future<bool> get hasConsented async {
    return await OneSignal.shared.userProvidedPrivacyConsent();
  }

  @override
  Future<void> grantConsent(bool value) async {
    await OneSignal.shared.consentGranted(value);
  }

  @override
  Future<void> disablePush(bool value) async {
    await OneSignal.shared.disablePush(value);
  }
}
