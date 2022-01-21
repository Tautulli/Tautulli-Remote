import 'package:package_info_plus/package_info_plus.dart';

abstract class PackageInformation {
  Future<String> get version;
}

class PackageInformationImpl implements PackageInformation {
  @override
  Future<String> get version async {
    return await PackageInfo.fromPlatform().then(
      (packageInfo) => packageInfo.version,
    );
  }
}
