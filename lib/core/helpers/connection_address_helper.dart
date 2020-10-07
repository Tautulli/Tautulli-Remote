/// Helper functions for manipulating a connection address.
class ConnectionAddressHelper {
  /// Parses a connection address into seperate components.
  ///
  /// Extracts a [protocol] and [domain] to construct a URL.
  /// Extracts a [user] and [password] for basic auth.
  static Map<String, dynamic> parse(String connectionAddress) {
    if (connectionAddress == null) {
      final Map<String, String> connectionAddressMap = {
        'protocol': null,
        'domain': null,
        'path': null,
      };
      return connectionAddressMap;
    }

    String protocol;
    String domain;
    String path;

    RegExp exp = RegExp(r"(http[s]?):\/\/([\S][^\/]+)([\S]*)");
    Iterable<Match> matches = exp.allMatches(connectionAddress);

    matches.forEach((m) {
      protocol = m.group(1);
      domain = m.group(2);
      path = m.group(3);
    });

    final Map<String, String> connectionAddressMap = {
      'protocol': protocol,
      'domain': domain,
      'path': path,
    };
    return connectionAddressMap;
  }
}
