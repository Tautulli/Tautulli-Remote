import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/clear_tautulli_image_cache_bloc.dart';
import '../../bloc/settings_bloc.dart';

class ClearTautulliImageCacheMultiserverDialog extends StatefulWidget {
  const ClearTautulliImageCacheMultiserverDialog({super.key});

  @override
  State<ClearTautulliImageCacheMultiserverDialog> createState() =>
      _ClearTautulliImageCacheMultiserverDialogState();
}

class _ClearTautulliImageCacheMultiserverDialogState
    extends State<ClearTautulliImageCacheMultiserverDialog> {
  ServerModel? selectedServer;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(LocaleKeys.clear_tautulli_image_cache_title).tr(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(LocaleKeys
                  .clear_tautulli_image_cache_dialog_multiserver_content)
              .tr(),
          const Gap(8),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              state as SettingsSuccess;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: state.serverList
                    .map(
                      (server) => RadioListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(server.plexName),
                        value: server,
                        groupValue: selectedServer,
                        onChanged: (ServerModel? value) {
                          setState(() {
                            selectedServer = value;
                          });
                        },
                      ),
                    )
                    .toList(),
              );
            },
          ),
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
            backgroundColor: selectedServer != null
                ? Theme.of(context).colorScheme.error
                : null,
          ),
          onPressed: selectedServer != null
              ? () {
                  context.read<ClearTautulliImageCacheBloc>().add(
                        ClearTautulliImageCacheStart(
                          server: selectedServer!,
                          settingsBloc: context.read<SettingsBloc>(),
                        ),
                      );
                  Navigator.of(context).pop(true);
                }
              : null,
          child: const Text(LocaleKeys.clear_button).tr(),
        ),
      ],
    );
  }
}
