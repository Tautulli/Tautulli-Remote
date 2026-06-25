import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rate_my_app/rate_my_app.dart';

import '../../dependency_injection.dart' as di;
import '../../features/logging/domain/usecases/logging.dart';

RateMyApp rateApp = RateMyApp(
  minDays: 30,
  minLaunches: 60,
  remindDays: 90,
  remindLaunches: 30,
);

/// Initializes RateMyApp, attempting to repair a corrupt DataStore if needed.
/// Returns false if init ultimately fails and the dialog should be skipped.
Future<bool> initRateApp() async {
  try {
    await rateApp.init();
    return true;
  } on PlatformException catch (e) {
    if (!Platform.isAndroid || e.message?.contains('preferences proto') != true) rethrow;

    di.sl<Logging>().warning('RateMyApp :: DataStore corruption detected, attempting repair');

    try {
      final supportDir = await getApplicationSupportDirectory();
      final datastoreDir = Directory('${supportDir.path}/datastore');
      if (await datastoreDir.exists()) {
        await datastoreDir.delete(recursive: true);
      }
      await rateApp.init();
      di.sl<Logging>().info('RateMyApp :: DataStore repair successful');
      return true;
    } catch (_) {
      di.sl<Logging>().error('RateMyApp :: DataStore repair failed, skipping rate dialog');
      return false;
    }
  }
}
