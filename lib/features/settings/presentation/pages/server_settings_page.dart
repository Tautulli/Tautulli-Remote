import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../core/widgets/list_tile_group.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../translations/locale_keys.g.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/dialogs/custom_header_type_dialog.dart';
import '../widgets/dialogs/delete_dialog.dart';
import '../widgets/list_tiles/custom_header_list_tile.dart';
import '../widgets/list_tiles/server_device_token_list_tile.dart';
import '../widgets/list_tiles/server_open_in_browser_list_tile.dart';
import '../widgets/list_tiles/server_primary_connection_list_tile.dart';
import '../widgets/list_tiles/server_secondary_connection_list_tile.dart';

class ServerSettingsPage extends StatelessWidget {
  final int serverId;

  const ServerSettingsPage({
    Key? key,
    required this.serverId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ServerSettingsView(
      serverId: serverId,
    );
  }
}

class ServerSettingsView extends StatelessWidget {
  final int serverId;

  const ServerSettingsView({
    Key? key,
    required this.serverId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        state as SettingsSuccess;

        final server = state.serverList.firstWhere(
          (server) => server.id == serverId,
        );

        // Sort headers and make sure Authorization is first
        server.customHeaders.sort((a, b) => a.key.compareTo(b.key));
        final index = server.customHeaders.indexWhere(
          (element) => element.key == 'Authorization',
        );
        if (index != -1) {
          final authHeader = server.customHeaders.removeAt(index);
          server.customHeaders.insert(0, authHeader);
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(server.plexName),
            actions: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.trash),
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
                    Navigator.of(context).pop();

                    context.read<SettingsBloc>().add(
                          SettingsDeleteServer(
                            id: serverId,
                            plexName: server.plexName,
                          ),
                        );
                  }
                },
              ),
            ],
          ),
          body: PageBody(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                ListTileGroup(
                  heading: LocaleKeys.connection_details_title.tr(),
                  listTiles: [
                    ServerPrimaryConnectionListTile(server: server),
                    ServerSecondaryConnectionListTile(server: server),
                    ServerDeviceTokenListTile(deviceToken: server.deviceToken),
                  ],
                ),
                const Gap(8),
                ListTileGroup(
                  heading: LocaleKeys.custom_http_headers_title.tr(),
                  listTiles: server.customHeaders
                      .map(
                        (header) => CustomHeaderListTile(
                          forRegistration: false,
                          tautulliId: server.tautulliId,
                          title: header.key,
                          subtitle: header.value,
                        ),
                      )
                      .toList(),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: const Text(
                          LocaleKeys.add_custom_http_header_button,
                        ).tr(),
                        onPressed: () async => await showDialog(
                          context: context,
                          builder: (context) => CustomHeaderTypeDialog(
                            forRegistration: false,
                            tautulliId: server.tautulliId,
                            currentHeaders: server.customHeaders,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(8),
                ListTileGroup(
                  heading: LocaleKeys.other_title.tr(),
                  listTiles: [
                    ServerOpenInBrowserListTile(server: server),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
