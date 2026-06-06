import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/settings_bloc.dart';
import 'dialogs/delete_ios_dialog.dart';

class DeleteServerIosButton extends StatelessWidget {
  final int serverId;
  final ServerModel server;

  const DeleteServerIosButton({
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
          builder: (_) => DeleteIosDialog(
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
