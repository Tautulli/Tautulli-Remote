import 'package:device_info/device_info.dart';

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
    final androidInfo = await deviceInfoPlugin.androidInfo;
    return androidInfo.model;
  }

  @override
  Future<String> get uniqueId async {
    final androidInfo = await deviceInfoPlugin.androidInfo;
    return androidInfo.androidId;
  }
}