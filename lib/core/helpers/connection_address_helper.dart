/// Helper functions for manipulating a connection address.
abstract class ConnectionAddressHelper {
  /// Parses a connection address into seperate components.
  ///
  /// Extracts a [protocol] and [domain] to construct a URL.
  /// Extracts a [user] and [password] for basic auth.
  Map<String, dynamic> parse(String connectionAddress);
}

class ConnectionAddressHelperImpl implements ConnectionAddressHelper {
  @override
  Map<String, dynamic> parse(String connectionAddress) {
    String protocol;
    String domain;
    String user;
    String password;

    RegExp exp = RegExp(r"^(http[s]?):\/\/((.+):(.+)@)*([^\s]+)");
    Iterable<Match> matches = exp.allMatches(connectionAddress);

    matches.forEach((m) {
      protocol = m.group(1);
      user = m.group(3);
      password = m.group(4);
      domain = m.group(5);
    });

    final Map<String, String> connectionAddressMap = {
      'protocol': protocol.trim(),
      'domain': domain.trim(),
      'user': user.trim(),
      'password': password.trim(),
    };
    return connectionAddressMap;
  }
}
