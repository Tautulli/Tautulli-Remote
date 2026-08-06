import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cryptography_flutter_plus/cryptography_flutter_plus.dart';
import 'package:cryptography_plus/cryptography_plus.dart';
import 'package:flutter_app_group_directory/flutter_app_group_directory.dart';

import '../../dependency_injection.dart' as di;
import '../../features/logging/domain/usecases/logging.dart';
import '../../features/settings/domain/usecases/settings.dart';

class NotificationHelper {
  // Kept from the OneSignal era on purpose: the app's SQLite database lives in
  // this container, so renaming it would orphan every existing user's data.
  static const _appGroupId = 'group.com.tautulli.tautulliRemote.onesignal';
  static const _cacheFilename = 'notification_action.json';

  /// Unwraps the notification envelope from an FCM message's data map.
  ///
  /// The relay sends the whole envelope as one JSON string under `payload`,
  /// because FCM coerces every value in a message's data map to a string and
  /// that would strip the types the envelope relies on. Falls back to the shape
  /// OneSignal used so a notification already in flight during the migration
  /// still routes correctly.
  static Map<String, dynamic>? unwrapPayload(Map<String, dynamic>? data) {
    if (data == null) return null;

    final payload = data['payload'];
    if (payload is String) {
      try {
        final decoded = jsonDecode(payload);
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } catch (e) {
        di.sl<Logging>().warning('NotificationHelper :: Failed to parse notification payload [$e]');
        return null;
      }
    }
    if (payload is Map) return Map<String, dynamic>.from(payload);

    final custom = data['custom'];
    if (custom is String) {
      try {
        final decoded = jsonDecode(custom);
        if (decoded is Map && decoded['a'] is Map) {
          return Map<String, dynamic>.from(decoded['a'] as Map);
        }
      } catch (_) {
        return null;
      }
    }

    return null;
  }

  // Reads the action the iOS extension recorded for the tapped notification.
  // Returns null on Android, when no entry matches, or when the entry names a
  // different server; the caller then decrypts instead, which is correct but pays
  // for the key derivation this cache exists to skip.
  //
  // [messageId] is what tells one notification's entry from another's.
  static Future<String?> readCachedAction(String? serverId, String? messageId) async {
    if (!Platform.isIOS || serverId == null || messageId == null) return null;

    try {
      final dir = await FlutterAppGroupDirectory.getAppGroupDirectory(_appGroupId);
      if (dir == null) return null;

      final file = File('${dir.path}/$_cacheFilename');
      if (!file.existsSync()) return null;

      final decoded = jsonDecode(await file.readAsString());
      if (decoded is! List) return null;

      final entries = decoded.whereType<Map>().toList();
      final index = entries.indexWhere((entry) => entry['message_id'] == messageId);
      if (index < 0) return null;

      final entry = entries.removeAt(index);
      // Only this notification's entry is dropped. The rest belong to
      // notifications still sitting in the shade, waiting to be tapped.
      await file.writeAsString(jsonEncode(entries));

      if (entry['server_id'] == serverId) {
        return entry['action'] as String?;
      }
    } catch (e) {
      di.sl<Logging>().warning('NotificationHelper :: Failed to read cached notification action [$e]');
    }

    return null;
  }

  static Future<Map<String, dynamic>?> extractAdditionalData(
    Map<String, dynamic>? data,
  ) async {
    if (data == null) return null;

    final server = await di.sl<Settings>().getServerByTautulliId(
      data['server_id'],
    );

    if (server != null && data['encrypted'] == true) {
      int? version = data['version'];
      String? salt = data['salt'];
      String? cipherText = data['cipher_text'];
      String? nonce = data['nonce'];

      if (salt != null && cipherText != null && nonce != null) {
        try {
          final Uint8List saltDecoded = base64Decode(salt);
          final Uint8List cipherTextDecoded = base64Decode(cipherText);
          final Uint8List nonceDecoded = base64Decode(nonce);

          final pbkdf2 = Pbkdf2(
            macAlgorithm: version == 2 ? Hmac.sha256() : Hmac.sha1(),
            iterations: version == 2 ? 600000 : 1000,
            bits: 32 * 8,
          );

          final secretKey = await pbkdf2.deriveKeyFromPassword(
            password: server.deviceToken,
            nonce: saltDecoded,
          );

          final algorithm = FlutterAesGcm.with256bits();

          final bytes = nonceDecoded + cipherTextDecoded;
          final secretBox = SecretBox.fromConcatenation(
            bytes,
            nonceLength: 16,
            macLength: algorithm.macAlgorithm.macLength,
          );

          final clearTextFlutter = utf8.decode(
            await algorithm.decrypt(secretBox, secretKey: secretKey),
          );

          return jsonDecode(clearTextFlutter);
        } catch (e) {
          di.sl<Logging>().warning('NotificationHelper :: Failed to decrypt notification data [$e]');
          return null;
        }
      }
    } else {
      final plainText = data['plain_text'];
      if (plainText is Map) return Map<String, dynamic>.from(plainText.cast<String, dynamic>());
      if (plainText is String) return jsonDecode(plainText) as Map<String, dynamic>?;
      return null;
    }

    return null;
  }
}
