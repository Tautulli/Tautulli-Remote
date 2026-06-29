import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/database/data/models/server_model.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/clear_tautulli_image_cache_bloc.dart';
import '../../../bloc/settings_bloc.dart';

class CupertinoStyleClearTautulliImageCacheDialog extends StatelessWidget {
  final ServerModel server;

  const CupertinoStyleClearTautulliImageCacheDialog({
    super.key,
    required this.server,
  });

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        state as SettingsSuccess;

        return CupertinoAlertDialog(
          title: const Text(LocaleKeys.clear_tautulli_image_cache_title).tr(args: [server.plexName]),
          content: const Text(LocaleKeys.clear_tautulli_image_cache_dialog_content).tr(args: [server.plexName]),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(LocaleKeys.cancel_title).tr(),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                context.read<ClearTautulliImageCacheBloc>().add(
                  ClearTautulliImageCacheStart(
                    server: state.appSettings.activeServer,
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
