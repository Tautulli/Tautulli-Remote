import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';

abstract class DeviceInfo {
  /// The end-user-visible name for the device.
  Future<String?> get model;

  /// Returns `'ios'` if platform is iOS, otherwise returns `'android'`
  Future<String> get platform;

  /// A unique identifier for the device.
  Future<String?> get uniqueId;

  /// The OS version of the device.
  Future<num> get version;
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
    } else {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      return iosInfo.identifierForVendor;
    }
  }

  @override
  Future<String> get platform async {
    final isIos = Platform.isIOS;
    if (isIos) {
      return 'ios';
    }
    return 'android';
  }

  @override
  Future<num> get version async {
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      return num.parse(androidInfo.version.release!);
    } else {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      return num.parse(iosInfo.systemVersion!);
    }
  }
}
