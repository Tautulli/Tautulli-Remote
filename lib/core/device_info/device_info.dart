import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';

abstract class DeviceInfo {
  /// The end-user-visible name for the device.
  Future<String> get model;

  /// A unique identifier for the device.
  Future<String> get uniqueId;
}

class DeviceInfoImpl implements DeviceInfo {
  final DeviceInfoPlugin deviceInfoPlugin;

  DeviceInfoImpl(this.deviceInfoPlugin);

  @override
  Future<String> get model async {
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      return androidInfo.model;
    } else {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      return iosInfo.utsname.machine;
    }
  }

  @override
  Future<String> get uniqueId async {
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      return androidInfo.androidId;
    } else {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      return iosInfo.identifierForVendor;
    }
  }
}
