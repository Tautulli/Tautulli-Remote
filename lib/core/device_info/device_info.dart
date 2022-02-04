import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

abstract class DeviceInfo {
  /// The end-user-visible name for the device.
  Future<String?> get model;

  /// Returns `'ios'` if platform is iOS, otherwise returns `'android'`
  Future<String> get platform;

  /// A unique identifier for the device.
  Future<String?> get uniqueId;
}

class DeviceInfoImpl implements DeviceInfo {
  final DeviceInfoPlugin deviceInfoPlugin;

  DeviceInfoImpl(this.deviceInfoPlugin);

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
      final androidInfo = await deviceInfoPlugin.androidInfo;
      return androidInfo.androidId;
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
}
