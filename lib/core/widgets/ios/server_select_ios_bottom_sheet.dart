import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../database/data/models/server_model.dart';
import 'custom_cupertino_list_section.dart';
import 'custom_notched_cupertino_list_tile.dart';
import 'ios_bottom_sheet_cancel_button.dart';
import 'page_scaffold_cupertino.dart';

class ServerSelectIosBottomSheet extends StatelessWidget {
  final ServerModel activeServer;
  final List<ServerModel> servers;

  const ServerSelectIosBottomSheet({
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

    return PageScaffoldCupertino(
      leading: const IosBottomSheetCancelButton(),
      //Todo: Translation string
      middle: Text('Select Server'),
      child: CustomCupertinoListSection(
        hasLeading: false,
        children: servers
            .map(
              (server) => CustomNotchedCupertinoListTile(
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
