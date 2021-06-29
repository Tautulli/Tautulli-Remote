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

  static Future<bool> hostResolvesToPublic(String host) async {
    final ipList = await InternetAddress.lookup(host);

    if (ipList.isEmpty) {
      return true;
    }

    if (!isPublic(ipList[0].address)) {
      return false;
    }

    return true;
  }

  static String parseIpFromUrl(String url) {
    String parsedIp = '';

    RegExp ipv4Exp = RegExp(r"http[s]?:\/\/([0-9,.]+)[\S]*");
    RegExp ipv6Exp = RegExp(r"http[s]?:\/\/([[a-f,0-9,:]+])[\S]*");

    if (ipv4Exp.hasMatch(url)) {
      Iterable<Match> ipv4Matches = ipv4Exp.allMatches(url);
      ipv4Matches.forEach((m) {
        parsedIp = m.group(1);
      });
    } else if (ipv6Exp.hasMatch(url)) {
      Iterable<Match> ipv6Matches = ipv6Exp.allMatches(url);
      ipv6Matches.forEach((m) {
        parsedIp = m.group(1);
      });
    }

    return parsedIp;
  }
}
