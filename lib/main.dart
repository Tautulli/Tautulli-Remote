import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:package_info/package_info.dart';

import 'features/announcements/presentation/bloc/announcements_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_health_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_subscription_bloc.dart';
import 'features/settings/domain/usecases/settings.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'injection_container.dart' as di;
import 'tautulli_remote.dart';

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
  InAppPurchaseConnection.enablePendingPurchases();
  await di.init();

  // Override global HttpClient to check for trusted cert hashes on certificate failure.
  final List<int> customCertHashList =
      await di.sl<Settings>().getCustomCertHashList();
  HttpOverrides.global = MyHttpOverrides(customCertHashList);

  // Get version information to determine if we should show the changelog
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  final runningVersion = packageInfo.version;
  final lastAppVersion = await di.sl<Settings>().getLastAppVersion();

  runApp(
    MultiBlocProvider(
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
        showChangelog: runningVersion != lastAppVersion,
      ),
    ),
  );
}
