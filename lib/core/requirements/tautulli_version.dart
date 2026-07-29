import 'package:version/version.dart';

class MinimumVersion {
  /// Minimum Tautulli version required for Tautulli Remote to function.
  static Version tautulliServer = Version(2, 10, 5);

  /// Minimum Tautulli version that delivers notifications through the push
  /// relay. Older servers still accept a registration, but have nowhere to put
  /// the push token, so they cannot notify this app once OneSignal shuts down.
  static Version tautulliServerPush = Version(2, 16, 0);

  /// Whether a server reporting [version] can deliver through the push relay.
  ///
  /// An unparsable or missing version is treated as capable: the alternative is
  /// warning every user whose server reports something unexpected.
  static bool supportsPush(String? version) {
    if (version == null) return true;

    try {
      return Version.parse(version.replaceFirst(RegExp('^v'), '')) >= tautulliServerPush;
    } catch (_) {
      return true;
    }
  }
}
