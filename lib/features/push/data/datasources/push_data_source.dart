import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/exception.dart';
import '../../../../core/network_info/network_info.dart';
import '../../../settings/domain/usecases/settings.dart';

/// Sent as the push token when notifications are unavailable, so the Tautulli
/// server can tell "declined" apart from "not registered yet".
const String pushDisabled = 'push-disabled';

/// Hex characters of the token digest that identify a device to the relay.
///
/// Sixteen so one value serves both correlations: the relay's request logs
/// print the first eight, its usage dataset records all sixteen.
const int relayDeviceIdLength = 16;

/// The relay that carries notifications from a Tautulli server to this device.
const String pushRelayUrl = 'https://relay.tautulliremote.com';

/// Relay lookups are only ever used to render status, so they must fail fast:
/// without a bound the diagnostics page waits forever on an unreachable relay.
const Duration _relayTimeout = Duration(seconds: 10);

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

/// How much of the fair use allowance this device has consumed.
///
/// Separate from [PushLimits]: the cap is a property of the relay and comes from
/// its health endpoint, while consumption is per device token and has to be
/// asked for specifically.
class PushUsage extends Equatable {
  final int? used;
  final int? remaining;
  final DateTime? resetsAt;

  const PushUsage({this.used, this.remaining, this.resetsAt});

  const PushUsage.unknown() : used = null, remaining = null, resetsAt = null;

  @override
  List<Object?> get props => [used, remaining, resetsAt];
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

  /// Provides the identifier the relay knows this device by.
  Future<String> get relayDeviceId;

  /// Provides this device's consumption of the fair use allowance.
  Future<PushUsage> get usage;

  /// Provides the push token used to register this device with a Tautulli server.
  ///
  /// Throws [PushTokenUnavailableException] when the token cannot be
  /// determined, rather than returning [pushDisabled].
  Future<String> get tokenForRegistration;

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
        final response = await client.get(Uri.parse('$pushRelayUrl/v1/health')).timeout(_relayTimeout);
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
      final response = await client.get(Uri.parse('$pushRelayUrl/v1/health')).timeout(_relayTimeout);
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
  Future<String> get relayDeviceId async {
    final deviceToken = await token;
    if (deviceToken == pushDisabled) return pushDisabled;

    // The same digest the relay derives, so a user can quote this instead of
    // the token, which is a bearer credential and must not leave the device.
    return sha256.convert(utf8.encode(deviceToken)).toString().substring(0, relayDeviceIdLength);
  }

  @override
  Future<PushUsage> get usage async {
    // Consumption is counted against the push token, so without one there is
    // nothing to ask about and no token to hand over.
    final deviceToken = await token;
    if (deviceToken == pushDisabled) return const PushUsage.unknown();

    try {
      final response = await client
          .post(
            Uri.parse('$pushRelayUrl/v1/quota'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'token': deviceToken}),
          )
          .timeout(_relayTimeout);
      if (response.statusCode >= 400) return const PushUsage.unknown();

      final rateLimits = json.decode(response.body)['rateLimits'];
      if (rateLimits is! Map) return const PushUsage.unknown();

      return PushUsage(
        used: rateLimits['used'] is int ? rateLimits['used'] as int : null,
        remaining: rateLimits['remaining'] is int ? rateLimits['remaining'] as int : null,
        resetsAt: DateTime.tryParse('${rateLimits['resetsAt']}'),
      );
    } catch (_) {
      return const PushUsage.unknown();
    }
  }

  @override
  Future<String> get token async {
    // Without consent there must be no token: asking for one re-creates the
    // registration the user just revoked, and handing it to a Tautulli server
    // would start notifications again behind their back.
    if (!await hasConsented) return pushDisabled;

    try {
      // Minting a token reaches out to FCM, which can stall on a network that
      // blocks it; bounded so status screens and registration cannot hang.
      final token = await messaging.getToken().timeout(_relayTimeout);
      if (token != null && token.isNotEmpty) {
        return token;
      }
      return pushDisabled;
    } catch (_) {
      return pushDisabled;
    }
  }

  @override
  Future<String> get tokenForRegistration async {
    // Notifications being switched off is a real answer, and the server is told
    // so. Anything else - a timeout, an FCM error, a token that never arrives -
    // is transient, and recording [pushDisabled] for it would tell the server to
    // stop notifying a device that is still expecting notifications, with
    // nothing in the app to show that it happened.
    if (!await hasConsented) return pushDisabled;
    if (!await hasNotificationPermission) return pushDisabled;

    try {
      final token = await messaging.getToken().timeout(_relayTimeout);
      if (token != null && token.isNotEmpty) {
        return token;
      }
    } catch (_) {
      // Falls through to the throw below.
    }

    throw PushTokenUnavailableException();
  }
}
