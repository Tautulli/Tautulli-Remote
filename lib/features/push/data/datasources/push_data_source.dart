import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

import '../../../../core/network_info/network_info.dart';
import '../../../settings/domain/usecases/settings.dart';

/// Sent as the push token when notifications are unavailable, so the Tautulli
/// server can tell "declined" apart from "not registered yet".
const String pushDisabled = 'push-disabled';

/// The relay that carries notifications from a Tautulli server to this device.
const String pushRelayUrl = 'https://relay.tautulliremote.com';

/// The relay's fair-use limit, as reported by its health endpoint.
///
/// [maximum] is `null` while the relay is still measuring real-world usage to
/// decide what the limit should be. That is not the same as "no limit ever": a
/// limit is expected, so anything shown to the user must say so.
class PushLimits extends Equatable {
  final bool enforced;
  final int? maximum;

  const PushLimits({required this.enforced, this.maximum});

  const PushLimits.unknown() : enforced = false, maximum = null;

  @override
  List<Object?> get props => [enforced, maximum];
}

abstract class PushDataSource {
  /// Disables or enables push notifications.
  Future<void> optIn(bool value);

  /// Grants or revokes consent based on the provided boolean.
  Future<void> grantConsent(bool value);

  /// Returns `true` if the user has consented to receiving notifications.
  Future<bool> get hasConsented;

  /// Returns `true` if the OS has granted notification permission.
  Future<bool> get hasNotificationPermission;

  /// Returns `true` if push notifications are enabled.
  Future<bool> get isOptedIn;

  /// Checks if the push relay is reachable.
  Future<bool> get isReachable;

  /// Indicates if this device can currently receive notifications.
  Future<bool> get isSubscribed;

  /// Requests notification permission from the OS.
  Future<bool> requestPermission();

  /// The relay's current fair-use limit.
  Future<PushLimits> get limits;

  /// Provides the push token used to address this device.
  ///
  /// Returns `'push-disabled'` if a token is unavailable.
  Future<String> get token;
}

class PushDataSourceImpl implements PushDataSource {
  final http.Client client;
  final FirebaseMessaging messaging;
  final NetworkInfo networkInfo;
  final Settings settings;

  PushDataSourceImpl({
    required this.client,
    required this.messaging,
    required this.networkInfo,
    required this.settings,
  });

  @override
  Future<void> optIn(bool value) async {
    if (value) {
      await messaging.setAutoInitEnabled(true);
      await messaging.getToken();
    } else {
      // Deleting the token is the only way to stop delivery outright; the app
      // re-registers with the disabled sentinel afterwards.
      await messaging.setAutoInitEnabled(false);
      await messaging.deleteToken();
    }
  }

  @override
  Future<void> grantConsent(bool value) async {
    // Recorded here rather than only by the bloc so that consent is durable
    // before a token is ever minted: `token` refuses to hand one out until
    // this is set, and registration reads it straight afterwards.
    await settings.setNotificationsConsented(value);
    await messaging.setAutoInitEnabled(value);
  }

  @override
  Future<bool> get hasConsented async {
    return settings.getNotificationsConsented();
  }

  @override
  Future<bool> get hasNotificationPermission async {
    final settings = await messaging.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  @override
  Future<bool> get isReachable async {
    if (await networkInfo.isConnected) {
      try {
        final response = await client.get(Uri.parse('$pushRelayUrl/v1/health'));
        return response.statusCode < 400;
      } catch (_) {
        return false;
      }
    }
    return false;
  }

  @override
  Future<bool> get isSubscribed async {
    if (!await hasNotificationPermission) return false;
    if (!await isOptedIn) return false;

    return await token != pushDisabled;
  }

  @override
  Future<bool> get isOptedIn async {
    return messaging.isAutoInitEnabled;
  }

  @override
  Future<bool> requestPermission() async {
    final settings = await messaging.requestPermission();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  @override
  Future<PushLimits> get limits async {
    try {
      final response = await client.get(Uri.parse('$pushRelayUrl/v1/health'));
      if (response.statusCode >= 400) return const PushLimits.unknown();

      final rateLimits = json.decode(response.body)['rateLimits'];
      if (rateLimits is! Map) return const PushLimits.unknown();

      return PushLimits(
        enforced: rateLimits['enforced'] == true,
        maximum: rateLimits['maximum'] is int ? rateLimits['maximum'] as int : null,
      );
    } catch (_) {
      return const PushLimits.unknown();
    }
  }

  @override
  Future<String> get token async {
    // Without consent there must be no token: asking for one re-creates the
    // registration the user just revoked, and handing it to a Tautulli server
    // would start notifications again behind their back.
    if (!await hasConsented) return pushDisabled;

    try {
      final token = await messaging.getToken();
      if (token != null && token.isNotEmpty) {
        return token;
      }
      return pushDisabled;
    } catch (_) {
      return pushDisabled;
    }
  }
}
