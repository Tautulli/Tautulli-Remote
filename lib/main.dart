import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/helpers/translation_helper.dart';
import 'dependency_injection.dart' as di;
import 'features/announcements/presentation/bloc/announcements_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_health_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_sub_bloc.dart';
import 'features/settings/presentation/bloc/registration_headers_bloc.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'tautulli_remote.dart';
import 'translations/codegen_loader.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await di.init();

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
        child: const TautulliRemote(),
      ),
    ),
  );
}
