// @dart=2.9

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quiver/strings.dart';

import 'core/helpers/translation_helper.dart';
import 'features/announcements/presentation/bloc/announcements_bloc.dart';
import 'features/logging/domain/usecases/logging.dart';
import 'features/onesignal/data/datasources/onesignal_data_source.dart';
import 'features/onesignal/presentation/bloc/onesignal_health_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_subscription_bloc.dart';
import 'features/settings/domain/usecases/register_device.dart';
import 'features/settings/domain/usecases/settings.dart';
import 'features/settings/presentation/bloc/register_device_headers_bloc.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/translate/presentation/bloc/translate_bloc.dart';
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

  // Update device registration after update
  if (versionMismatch && serverList.isNotEmpty) {
    di.sl<Logging>().info(
          'General: Version changed, updating registration.',
        );
    // Skip registration update if user has consented but user ID is empty.
    // This condition will be caught by the app triggering a registration when
    // the user ID changes from empty to valid.
    if (await di.sl<OneSignalDataSource>().hasConsented &&
        isNotEmpty(await di.sl<OneSignalDataSource>().userId)) {
      for (var i = 0; i < serverList.length; i++) {
        await di.sl<RegisterDevice>().call(
              connectionProtocol: serverList[i].primaryConnectionProtocol,
              connectionDomain: serverList[i].primaryConnectionDomain,
              connectionPath: serverList[i].primaryConnectionPath,
              deviceToken: serverList[i].deviceToken,
            );
      }
    } else {
      di.sl<Logging>().error(
            'General: Consent & user ID mismatch, skipping registration update.',
          );
    }
  }

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: TranslationHelper.supportedLocales(),
      fallbackLocale: const Locale('en'),
      useFallbackTranslations: true,
      assetLoader: const CodegenLoader(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SettingsBloc>(
            create: (context) => di.sl<SettingsBloc>(),
          ),
          BlocProvider<RegisterDeviceHeadersBloc>(
            create: (context) => di.sl<RegisterDeviceHeadersBloc>(),
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
          BlocProvider<TranslateBloc>(
            create: (context) => di.sl<TranslateBloc>(),
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
