import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:system_theme/system_theme.dart';

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
  await SystemTheme.accentColor.load();

  // Override global HttpClient to check for trusted cert hashes on certificate failure.
  final List<int> customCertHashList = di.sl<Settings>().getCustomCertHashList();
  HttpOverrides.global = MyHttpOverrides(customCertHashList);

  Future<String?> calculateInitialRoute() async {
    final runningVersion = await PackageInformationImpl().version;
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
      }
    }

    if (runningVersion != lastAppVersion) {
      await di.sl<Settings>().setLastAppVersion(runningVersion);
      await di.sl<Settings>().setRegistrationUpdateNeeded(true);
      routeToReturn ??= '/changelog';
    }

    return Future.value(routeToReturn);
  }

  final initialRoute = await calculateInitialRoute();

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
            create: (context) => di.sl<AnnouncementsBloc>(),
          ),
          BlocProvider(
            create: (context) => di.sl<GeoIpBloc>(),
          ),
          BlocProvider(
            create: (context) => di.sl<OneSignalHealthBloc>(),
          ),
          BlocProvider(
            create: (context) => di.sl<OneSignalPrivacyBloc>(),
          ),
          BlocProvider(
            create: (context) => di.sl<OneSignalSubBloc>(),
          ),
          BlocProvider(
            create: (context) => di.sl<RegistrationHeadersBloc>(),
          ),
          BlocProvider(
            create: (context) => di.sl<SettingsBloc>(),
          ),
        ],
        child: TautulliRemote(initialRoute: initialRoute),
      ),
    ),
  );
}
