import 'dart:io';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:system_theme/system_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'core/global_keys/global_keys.dart';
import 'core/helpers/translation_helper.dart';
import 'core/package_information/package_information.dart';
import 'dependency_injection.dart' as di;
import 'features/announcements/presentation/bloc/announcements_bloc.dart';
import 'features/geo_ip/presentation/bloc/geo_ip_bloc.dart';
import 'features/push/presentation/bloc/push_health_bloc.dart';
import 'features/push/presentation/bloc/push_privacy_bloc.dart';
import 'features/push/presentation/bloc/push_sub_bloc.dart';
import 'features/settings/domain/usecases/settings.dart';
import 'features/settings/presentation/bloc/registration_headers_bloc.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'tautulli_remote.dart';
import 'translations/codegen_loader.g.dart';

/// Create an [HttpOverride] for [createHttpClient] to check cert failures
/// against the saved cert hash list.
class MyHttpOverrides extends HttpOverrides {
  final Settings settings;

  MyHttpOverrides(this.settings);

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        final certHashCode = cert.pem.hashCode;
        return settings.getCustomCertHashList().contains(certHashCode);
      };
  }
}

/// Network I/O failures are environmental, not app defects. When one reaches a
/// global handler (an uncaught async error, or an image-load failure that
/// cached_network_image reports via FlutterError) record it non-fatal so it
/// stays visible without inflating the crash-free rate.
bool _isNetworkError(Object error) =>
    error is SocketException ||
    error is HandshakeException ||
    error is HttpException ||
    error is http.ClientException;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // Load intl locale symbol data before any DateFormat use (e.g. FLog timestamps
  // during DB init) so early-startup logging can't throw LocaleDataException.
  await initializeDateFormatting();
  TranslationHelper.registerTimeagoLocales();
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

  // Only real release builds report. Debug and profile runs from a dev machine
  // otherwise land in the production dashboard indistinguishable from user crashes,
  // including debug-only assert failures that cannot occur in a release build.
  // Set unconditionally on every launch so the persisted native flag self-corrects.
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kReleaseMode);

  // Route framework errors to Crashlytics. Network I/O failures (e.g. image-load
  // errors that cached_network_image reports through FlutterError) are environmental,
  // not app defects, so record them as non-fatal to keep them visible without
  // inflating the crash rate; everything else stays fatal.
  FlutterError.onError = (details) {
    FirebaseCrashlytics.instance.recordFlutterError(
      details,
      fatal: !_isNetworkError(details.exception),
    );
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework
  // to Crashlytics, with the same network-error classification.
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: !_isNetworkError(error));
    return true;
  };

  // Override global HttpClient to check for trusted cert hashes on certificate failure.
  HttpOverrides.global = MyHttpOverrides(di.sl<Settings>());

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
            create: (context) => di.sl<PushHealthBloc>(),
          ),
          BlocProvider(
            create: (context) => di.sl<PushPrivacyBloc>(param1: context.read<SettingsBloc>()),
          ),
          BlocProvider(
            create: (context) => di.sl<PushSubBloc>(),
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
