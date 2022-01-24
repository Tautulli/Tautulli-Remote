import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../pages/status_page.dart';

class SettingsNotLoaded extends StatelessWidget {
  const SettingsNotLoaded({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsInProgress) {
          return const StatusPage(
            message: 'Settings are loading.',
            action: CircularProgressIndicator(),
          );
        }
        if (state is SettingsFailure) {
          return StatusPage(
            message: 'Settings failed to load.',
            action: ElevatedButton(
              onPressed: () async {
                await launch('https://tautulli.com/#support');
              },
              child: const Text('CONTACT SUPPORT'),
            ),
          );
        }
        return StatusPage(
          message: 'Unknown error with settings.',
          action: ElevatedButton(
            onPressed: () async {
              await launch('https://tautulli.com/#support');
            },
            child: const Text('CONTACT SUPPORT'),
          ),
        );
      },
    );
  }
}
