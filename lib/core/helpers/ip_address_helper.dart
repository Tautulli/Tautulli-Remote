import 'dart:io';

class IpAddressHelper {
  /// Returns true if IP address is not a loopback, link local, or private IP
  ///
  /// Throws a generic exception if [ipAddress] cannot be parsed
  static bool isPublic(String ipAddress) {
    final parsedAddress = InternetAddress.tryParse(ipAddress);

    if (parsedAddress == null) {
      throw Exception();
    }

    if (parsedAddress.isLinkLocal || parsedAddress.isLoopback) {
      return false;
    }

    if (parsedAddress.type == InternetAddressType.IPv4) {
      RegExp privateV4 = RegExp(
        r"(^192\.168\.([0-9]|[0-9][0-9]|[0-2][0-5][0-5])\.([0-9]|[0-9][0-9]|[0-2][0-5][0-5])$)|(^172\.([1][6-9]|[2][0-9]|[3][0-1])\.([0-9]|[0-9][0-9]|[0-2][0-5][0-5])\.([0-9]|[0-9][0-9]|[0-2][0-5][0-5])$)|(^10\.([0-9]|[0-9][0-9]|[0-2][0-5][0-5])\.([0-9]|[0-9][0-9]|[0-2][0-5][0-5])\.([0-9]|[0-9][0-9]|[0-2][0-5][0-5])$)",
      );

      if (privateV4.hasMatch(parsedAddress.address)) {
        return false;
      }
    }

    if (parsedAddress.type == InternetAddressType.IPv6) {
      if (parsedAddress.address.startsWith('fe80')) {
        return false;
      }
    }

    return true;
  }
}
