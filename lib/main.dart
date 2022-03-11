import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tautulli_remote/core/package_information/package_information.dart';

import 'core/helpers/translation_helper.dart';
import 'dependency_injection.dart' as di;
import 'features/announcements/presentation/bloc/announcements_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_health_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_sub_bloc.dart';
import 'features/settings/domain/usecases/settings.dart';
import 'features/settings/presentation/bloc/registration_headers_bloc.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'tautulli_remote.dart';
import 'translations/codegen_loader.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await di.init();

  Future<String?> calculateInitialRoute() async {
    final runningVersion = await PackageInformationImpl().version;
    final lastAppVersion = await di.sl<Settings>().getLastAppVersion();

    if (runningVersion != lastAppVersion) {
      await di.sl<Settings>().setLastAppVersion(runningVersion);
      return Future.value('/changelog');
    }
    return Future.value(null);
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
