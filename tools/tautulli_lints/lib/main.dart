import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';

import 'src/missing_locale_subscription.dart';

final plugin = _TautulliLintsPlugin();

class _TautulliLintsPlugin extends Plugin {
  @override
  String get name => 'tautulli_lints';

  @override
  void register(PluginRegistry registry) {
    registry.registerWarningRule(MissingLocaleSubscription());
  }
}
