import 'dart:io';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:system_theme/system_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';

import 'package:google_fonts/google_fonts.dart';

import 'core/global_keys/global_keys.dart';
import 'core/helpers/translation_helper.dart';
import 'core/package_information/package_information.dart';
import 'dependency_injection.dart' as di;
import 'features/announcements/presentation/bloc/announcements_bloc.dart';
import 'features/geo_ip/presentation/bloc/geo_ip_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_health_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_sub_bloc.dart';
import 'features/settings/domain/usecases/settings.dart';
import 'features/settings/presentation/bloc/registration_headers_bloc.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'tautulli_remote.dart';
import 'translations/codegen_loader.g.dart';

/// Create an [HttpOverride] for [createHttpClient] to check cert failures
/// against the saved cert hash list.
class MyHttpOverrides extends HttpOverrides {
  final List<int> customCertHashList;

  MyHttpOverrides(this.customCertHashList);

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        int certHashCode = cert.pem.hashCode;

        if (customCertHashList.contains(certHashCode)) {
          return true;
        }
        return false;
      };
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await di.init();
  GoogleFonts.config.allowRuntimeFetching = false;
  await SystemTheme.accentColor.load();

  if (Firebase.apps.isEmpty) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      // Crashlytics is not yet configured at this point, so log via debugPrint
      // as a fallback before rethrowing.
      debugPrint('Firebase initialization failed: $e');
      rethrow;
    }
  }

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Override global HttpClient to check for trusted cert hashes on certificate failure.
  final List<int> customCertHashList = di.sl<Settings>().getCustomCertHashList();
  HttpOverrides.global = MyHttpOverrides(customCertHashList);

  Future<String?> calculateInitialRoute() async {
    final runningVersion = await di.sl<PackageInformation>().version;
    final lastAppVersion = di.sl<Settings>().getLastAppVersion();
    final bool wizardComplete = di.sl<Settings>().getWizardComplete();

    String? routeToReturn;

    if (!wizardComplete) {
      final serversExist = await di.sl<Settings>().getAllServers().then(
        (value) => value.isNotEmpty,
      );
      // Mark wizard as complete for users who added servers before wizard existed
      if (serversExist) {
        await di.sl<Settings>().setWizardComplete(true);
      } else {
        routeToReturn ??= '/wizard';
        await di.sl<Settings>().setLastAppVersion(runningVersion);
      }
    } else if (runningVersion != lastAppVersion) {
      await di.sl<Settings>().setLastAppVersion(runningVersion);
      await di.sl<Settings>().setRegistrationUpdateNeeded(true);
      routeToReturn ??= '/changelog';
    }

    return Future.value(routeToReturn);
  }

  appInitialRoute.value = await calculateInitialRoute();

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: TranslationHelper.supportedLocales(),
      fallbackLocale: const Locale('en'),
      useFallbackTranslations: true,
      assetLoader: const CodegenLoader(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => di.sl<SettingsBloc>(),
          ),
          BlocProvider(
            create: (context) => di.sl<AnnouncementsBloc>(),
          ),
          BlocProvider(
            create: (context) => di.sl<GeoIpBloc>(param1: context.read<SettingsBloc>()),
          ),
          BlocProvider(
            create: (context) => di.sl<OneSignalHealthBloc>(),
          ),
          BlocProvider(
            create: (context) => di.sl<OneSignalPrivacyBloc>(param1: context.read<SettingsBloc>()),
          ),
          BlocProvider(
            create: (context) => di.sl<OneSignalSubBloc>(),
          ),
          BlocProvider(
            create: (context) => di.sl<RegistrationHeadersBloc>(),
          ),
        ],
        child: const TautulliRemote(),
      ),
    ),
  );
}
