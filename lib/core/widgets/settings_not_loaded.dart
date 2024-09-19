import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../translations/locale_keys.g.dart';
import '../pages/status_page.dart';

class SettingsNotLoaded extends StatelessWidget {
  const SettingsNotLoaded({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsInProgress) {
          return StatusPage(
            message: LocaleKeys.settings_loading_message.tr(),
            action: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          );
        }
        if (state is SettingsFailure) {
          return StatusPage(
            message: LocaleKeys.settings_load_failed_message.tr(),
            action: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () async {
                await launchUrlString(
                  mode: LaunchMode.externalApplication,
                  'https://tautulli.com/#support',
                );
              },
              child: const Text(LocaleKeys.contact_support_title).tr(),
            ),
          );
        }
        return StatusPage(
          message: LocaleKeys.settings_load_error_message.tr(),
          action: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () async {
              await launchUrlString(
                mode: LaunchMode.externalApplication,
                'https://tautulli.com/#support',
              );
            },
            child: const Text(LocaleKeys.contact_support_title).tr(),
          ),
        );
      },
    );
  }
}
