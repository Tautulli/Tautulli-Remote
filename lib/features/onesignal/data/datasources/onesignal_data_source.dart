import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../../../core/network_info/network_info.dart';
import '../../../settings/domain/usecases/settings.dart';

abstract class OneSignalDataSource {
  /// Disables or enables push notifications
  Future<void> optIn(bool value);

  /// Grants or revokes consent based on the provided boolean.
  Future<void> grantConsent(bool value);

  /// Returns `true` if the user has granted consent to the OneSignal SDK.
  Future<bool> get hasConsented;

  /// Returns `true` if the OneSignal SDK shows user has granted notification permission.
  Future<bool> get hasNotificationPermission;

  /// Checks if he OneSignal SDK has push notifications enabled.
  Future<bool> get isOptedIn;

  /// Checks if `https://onesignal.com` is reachable.
  Future<bool> get isReachable;

  /// Indicates if the user is subscribed to OneSignal.
  Future<bool> get isSubscribed;

  /// Provides the OneSignal User ID (AKA playerID).
  ///
  /// Returns `'onesignal-disabled'` if an error is thrown.
  Future<String> get userId;
}

class OneSignalDataSourceImpl implements OneSignalDataSource {
  final http.Client client;
  final NetworkInfo networkInfo;
  final Settings settings;

  OneSignalDataSourceImpl({
    required this.client,
    required this.networkInfo,
    required this.settings,
  });

  @override
  Future<void> optIn(bool value) async {
    if (value == false) {
      await OneSignal.User.pushSubscription.optOut();
    } else {
      await OneSignal.User.pushSubscription.optIn();
    }
  }

  @override
  Future<void> grantConsent(bool value) async {
    await OneSignal.consentGiven(value);
  }

  @override
  Future<bool> get hasConsented async {
    return settings.getOneSignalConsented();
  }

  @override
  Future<bool> get hasNotificationPermission async {
    return OneSignal.Notifications.permission;
  }

  @override
  Future<bool> get isReachable async {
    if (await networkInfo.isConnected) {
      try {
        final response = await client.head(Uri.parse('https://onesignal.com'));
        return response.statusCode < 400;
      } catch (_) {
        return false;
      }
    }
    return false;
  }

  @override
  Future<bool> get isSubscribed async {
    final token = OneSignal.User.pushSubscription.token;
    final userId = OneSignal.User.pushSubscription.id;
    final optedIn = OneSignal.User.pushSubscription.optedIn;

    return token != null && userId != null && optedIn == true;
  }

  @override
  Future<bool> get isOptedIn async {
    final optedIn = OneSignal.User.pushSubscription.optedIn;

    if (optedIn != null) {
      return optedIn;
    } else {
      return false;
    }
  }

  @override
  Future<String> get userId async {
    try {
      final userId = OneSignal.User.pushSubscription.id;
      if (userId != null) {
        return userId;
      }
      return 'onesignal-disabled';
    } catch (_) {
      return 'onesignal-disabled';
    }
  }
}
