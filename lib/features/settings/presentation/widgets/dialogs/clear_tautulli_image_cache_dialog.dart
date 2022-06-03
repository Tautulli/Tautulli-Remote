import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/clear_tautulli_image_cache_bloc.dart';
import '../../bloc/settings_bloc.dart';

class ClearTautulliImageCacheDialog extends StatelessWidget {
  const ClearTautulliImageCacheDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        state as SettingsSuccess;

        return AlertDialog(
          title: const Text(LocaleKeys.clear_tautulli_image_cache_title).tr(),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(LocaleKeys.clear_tautulli_image_cache_dialog_content)
                  .tr(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(LocaleKeys.cancel_button).tr(),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () {
                context.read<ClearTautulliImageCacheBloc>().add(
                      ClearTautulliImageCacheStart(
                        server: state.appSettings.activeServer,
                        settingsBloc: context.read<SettingsBloc>(),
                      ),
                    );
                Navigator.of(context).pop(true);
              },
              child: const Text(LocaleKeys.clear_button).tr(),
            ),
          ],
        );
      },
    );
  }
}
