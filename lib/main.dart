import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dependency_injection.dart' as di;
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'tautulli_remote.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<SettingsBloc>(),
        ),
      ],
      child: const TautulliRemote(),
    ),
  );
}
