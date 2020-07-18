import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/onesignal/presentation/bloc/onesignal_health_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_subscription_bloc.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'injection_container.dart' as di;
import 'tautulli_remote.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<SettingsBloc>(
          create: (context) => di.sl<SettingsBloc>()..add(SettingsLoad()),
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
      ],
      child: TautulliRemote(),
    ),
  );
}
