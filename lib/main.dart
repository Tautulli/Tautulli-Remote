import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'features/announcements/presentation/bloc/announcements_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_health_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_subscription_bloc.dart';
import 'features/settings/domain/usecases/register_device.dart';
import 'features/settings/domain/usecases/settings.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'injection_container.dart' as di;
import 'tautulli_remote.dart';
import 'translations/codegen_loader.g.dart';

/// Create an [HttpOverride] for [createHttpClient] to check cert failures
/// against the saved cert hash list
class MyHttpOverrides extends HttpOverrides {
  final List<int> customCertHashList;

  MyHttpOverrides(this.customCertHashList);

  @override
  HttpClient createHttpClient(SecurityContext context) {
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

  // Override global HttpClient to check for trusted cert hashes on certificate failure.
  final List<int> customCertHashList =
      await di.sl<Settings>().getCustomCertHashList();
  HttpOverrides.global = MyHttpOverrides(customCertHashList);

  // Get version information to determine if we should show the changelog or wizard
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  final runningVersion = packageInfo.version;
  final lastAppVersion = await di.sl<Settings>().getLastAppVersion();
  final wizardCompleteStatus =
      await di.sl<Settings>().getWizardCompleteStatus();
  final serverList = await di.sl<Settings>().getAllServers();

  final bool versionMismatch = runningVersion != lastAppVersion;

  if (versionMismatch && serverList.isNotEmpty) {
    for (var i = 0; i < serverList.length; i++) {
      await di.sl<RegisterDevice>().call(
            connectionProtocol: serverList[i].primaryConnectionProtocol,
            connectionDomain: serverList[i].primaryConnectionDomain,
            connectionPath: serverList[i].primaryConnectionPath,
            deviceToken: serverList[i].deviceToken,
          );
    }
  }

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: const [
        Locale('de'),
        Locale('el'),
        Locale('en'),
        Locale('es'),
        Locale('fr'),
        Locale('it'),
        Locale('nl'),
        Locale('pt', 'BR'),
        Locale('pt', 'PT'),
      ],
      fallbackLocale: const Locale('en'),
      useFallbackTranslations: true,
      assetLoader: const CodegenLoader(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SettingsBloc>(
            create: (context) => di.sl<SettingsBloc>(),
          ),
          BlocProvider<OneSignalHealthBloc>(
            create: (context) => di.sl<OneSignalHealthBloc>(),
          ),
          BlocProvider<OneSignalSubscriptionBloc>(
            create: (context) => di.sl<OneSignalSubscriptionBloc>()
              ..add(OneSignalSubscriptionCheck()),
          ),
          BlocProvider<OneSignalPrivacyBloc>(
            create: (context) => di.sl<OneSignalPrivacyBloc>()
              ..add(OneSignalPrivacyCheckConsent()),
          ),
          BlocProvider<AnnouncementsBloc>(
            create: (context) =>
                di.sl<AnnouncementsBloc>()..add(AnnouncementsFetch()),
          ),
        ],
        child: TautulliRemote(
          showWizard: (wizardCompleteStatus != null && !wizardCompleteStatus) ||
              (wizardCompleteStatus == null && serverList.isEmpty),
          showChangelog: versionMismatch,
        ),
      ),
    ),
  );
}
