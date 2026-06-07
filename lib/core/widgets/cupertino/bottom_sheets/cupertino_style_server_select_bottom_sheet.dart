import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../../database/data/models/server_model.dart';
import '../cupertino_style_modal_popup_scaffold.dart';
import '../cupertino_style_list_section.dart';
import '../cupertino_style_notched_cupertino_list_tile.dart';
import '../buttons/cupertino_style_bottom_sheet_cancel_button.dart';

class CupertinoStyleServerSelectBottomSheet extends StatelessWidget {
  final ServerModel activeServer;
  final List<ServerModel> servers;

  const CupertinoStyleServerSelectBottomSheet({
    super.key,
    required this.activeServer,
    required this.servers,
  });

  @override
  Widget build(BuildContext context) {
    void serverChanged(ServerModel server) {
      if (server.id != activeServer.id) {
        context.read<SettingsBloc>().add(
          SettingsUpdateActiveServer(
            activeServer: server,
          ),
        );
      }
      Navigator.of(context).pop();
    }

    return CupertinoStyleModalPopupScaffold(
      leading: const CupertinoStyleBottomSheetCancelButton(),
      //Todo: Translation string
      middleText: 'Select Server',
      child: CupertinoStyleListSection(
        hasLeading: false,
        children: servers
            .map(
              (server) => CupertinoStyleNotchedCupertinoListTile(
                titleText: server.plexName,
                trailing: server.id == activeServer.id ? const Icon(CupertinoIcons.checkmark_alt) : null,
                onTap: () => serverChanged(server),
              ),
            )
            .toList(),
      ),
    );
  }
}
