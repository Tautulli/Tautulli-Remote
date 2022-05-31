import 'dart:io';

class IpAddressHelper {
  /// Returns true if IP address is not a loopback, link local, or private IP.
  ///
  /// Throws a generic exception if [ipAddress] cannot be parsed.
  static bool isPublic(String ipAddress) {
    final parsedAddress = InternetAddress.tryParse(ipAddress);

    if (parsedAddress == null) {
      throw Exception();
    }

    if (parsedAddress.isLinkLocal || parsedAddress.isLoopback) {
      return false;
    }

    if (parsedAddress.type == InternetAddressType.IPv4) {
      List<int> octets =
          parsedAddress.address.split('.').map((e) => int.parse(e)).toList();

      if ((octets[0] == 10) ||
          (octets[0] == 172 && octets[1] >= 16 && octets[1] <= 31) ||
          (octets[0] == 192 && octets[1] == 168)) {
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
