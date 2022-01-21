import 'package:flutter/material.dart';

import 'tautulli_remote.dart';
import 'dependency_injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(
    const TautulliRemote(),
  );
}
