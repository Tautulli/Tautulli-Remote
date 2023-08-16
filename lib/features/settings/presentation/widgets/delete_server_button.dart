import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../translations/locale_keys.g.dart';
import '../bloc/settings_bloc.dart';
import 'dialogs/delete_dialog.dart';

class DeleteServerButton extends StatelessWidget {
  final bool isWizard;
  final int serverId;
  final ServerModel server;

  const DeleteServerButton({
    super.key,
    this.isWizard = false,
    required this.serverId,
    required this.server,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: FaIcon(
        FontAwesomeIcons.trash,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      onPressed: () async {
        final result = await showDialog(
          context: context,
          builder: (_) => DeleteDialog(
            title: const Text(
              LocaleKeys.server_delete_dialog_title,
            ).tr(args: [server.plexName]),
          ),
        );

        if (result) {
          if (!isWizard) Navigator.of(context).pop();

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
