import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/clear_tautulli_image_cache_bloc.dart';
import '../../bloc/settings_bloc.dart';

class ClearTautulliImageCacheDialog extends StatelessWidget {
  final ServerModel server;

  const ClearTautulliImageCacheDialog({
    super.key,
    required this.server,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        state as SettingsSuccess;

        return AlertDialog(
          title: const Text(LocaleKeys.clear_tautulli_image_cache_title).tr(
            args: [server.plexName],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                LocaleKeys.clear_tautulli_image_cache_dialog_content,
              ).tr(
                args: [server.plexName],
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(LocaleKeys.cancel_title).tr(),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
                foregroundColor: Theme.of(context).colorScheme.onSurface,
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
              child: const Text(LocaleKeys.clear_title).tr(),
            ),
          ],
        );
      },
    );
  }
}
