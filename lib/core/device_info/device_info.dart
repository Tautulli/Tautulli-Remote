import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:version/version.dart';

abstract class DeviceInfo {
  /// The end-user-visible name for the device.
  Future<String?> get model;

  /// Returns `'ios'` if platform is iOS, otherwise returns `'android'`
  String get platform;

  /// A unique identifier for the device.
  Future<String?> get uniqueId;

  /// The OS version of the device.
  Future<Version> get version;
}

class DeviceInfoImpl implements DeviceInfo {
  final AndroidId androidId;
  final DeviceInfoPlugin deviceInfoPlugin;

  DeviceInfoImpl({
    required this.androidId,
    required this.deviceInfoPlugin,
  });

  @override
  Future<String?> get model async {
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      return androidInfo.model;
    } else {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      return iosInfo.name;
    }
  }

  @override
  Future<String?> get uniqueId async {
    if (Platform.isAndroid) {
      return await androidId.getId();
    }

    // identifierForVendor has no value between a restart and the first unlock,
    // and Apple's remedy is to ask again rather than stand in anything else: a
    // Tautulli server keys its devices on whatever it was told, so a placeholder
    // would take over the row belonging to another device that sent the same one.
    // Each retry reads through its own plugin, because DeviceInfoPlugin caches
    // iosInfo and the injected one is a singleton: asking it again would only
    // hand back the empty answer it already stored.
    for (var attempt = 0; attempt < 3; attempt++) {
      final plugin = attempt == 0 ? deviceInfoPlugin : DeviceInfoPlugin();
      final identifier = (await plugin.iosInfo).identifierForVendor;
      if (identifier != null) return identifier;

      await Future.delayed(const Duration(milliseconds: 200));
    }

    return null;
  }

  @override
  String get platform {
    final isIos = Platform.isIOS;
    if (isIos) {
      return 'ios';
    }
    return 'android';
  }

  @override
  Future<Version> get version async {
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      return Version.parse(androidInfo.version.release);
    } else {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      return Version.parse(iosInfo.systemVersion);
    }
  }
}
