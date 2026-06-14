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
  static const _appGroupId = 'group.com.tautulli.tautulliRemote.onesignal';
  static const _cacheFilename = 'notification_action.json';

  // Reads the action cached by the iOS NotificationServiceExtension.
  // Returns null on Android, if the file is absent, or if server_id doesn't match.
  static Future<String?> readCachedAction(String? serverId) async {
    if (!Platform.isIOS || serverId == null) return null;

    try {
      final dir = await FlutterAppGroupDirectory.getAppGroupDirectory(_appGroupId);
      if (dir == null) return null;

      final file = File('${dir.path}/$_cacheFilename');
      if (!file.existsSync()) return null;

      final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      await file.delete();

      if (json['server_id'] == serverId) {
        return json['action'] as String?;
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
      }
    } else {
      return jsonDecode(data['plain_text']);
    }

    return null;
  }
}
