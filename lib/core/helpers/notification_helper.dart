import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:cryptography_flutter/cryptography_flutter.dart';

import '../../dependency_injection.dart' as di;
import '../../features/settings/domain/usecases/settings.dart';

class NotificationHelper {
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
