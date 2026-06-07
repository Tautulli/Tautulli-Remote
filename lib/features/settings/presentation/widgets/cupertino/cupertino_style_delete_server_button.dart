import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/settings_bloc.dart';
import 'dialogs/cupertino_style_delete_dialog.dart';

class CupertinoStyleDeleteServerButton extends StatelessWidget {
  final int serverId;
  final ServerModel server;

  const CupertinoStyleDeleteServerButton({
    super.key,
    required this.serverId,
    required this.server,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(8),
      child: Icon(
        CupertinoIcons.trash_fill,
        color: ThemeHelper.cupertinoNavigationBarItemColor(),
      ),
      onPressed: () async {
        final result = await showCupertinoDialog(
          context: context,
          builder: (_) => CupertinoStyleDeleteDialog(
            title:
                const Text(
                  LocaleKeys.server_delete_dialog_title,
                ).tr(
                  args: [server.plexName],
                ),
          ),
        );

        if (result) {
          context.read<SettingsBloc>().add(
            SettingsDeleteServer(
              id: serverId,
              plexName: server.plexName,
            ),
          );
        }
      },
    );
  }
}
