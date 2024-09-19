import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../core/types/bloc_status.dart';
import '../../../../core/widgets/custom_list_tile.dart';
import '../../../../core/widgets/list_tile_group.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../bloc/clear_tautulli_image_cache_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/delete_server_button.dart';
import '../widgets/dialogs/clear_tautulli_image_cache_dialog.dart';
import '../widgets/dialogs/custom_header_type_dialog.dart';
import '../widgets/list_tiles/custom_header_list_tile.dart';
import '../widgets/list_tiles/server_device_token_list_tile.dart';
import '../widgets/list_tiles/server_open_in_browser_list_tile.dart';
import '../widgets/list_tiles/server_primary_connection_list_tile.dart';
import '../widgets/list_tiles/server_secondary_connection_list_tile.dart';

class ServerSettingsPage extends StatelessWidget {
  final int serverId;

  const ServerSettingsPage({
    super.key,
    required this.serverId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ClearTautulliImageCacheBloc>(),
      child: ServerSettingsView(
        serverId: serverId,
      ),
    );
  }
}

class ServerSettingsView extends StatelessWidget {
  final int serverId;

  const ServerSettingsView({
    super.key,
    required this.serverId,
  });

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
            forceMaterialTransparency: true,
            title: Text(server.plexName),
            actions: [
              DeleteServerButton(
                serverId: serverId,
                server: server,
              ),
            ],
          ),
          body: BlocListener<ClearTautulliImageCacheBloc, ClearTautulliImageCacheState>(
            listener: (context, state) {
              if (state.server != null) {
                if (state.status == BlocStatus.success) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        LocaleKeys.clear_tautulli_image_cache_success_snackbar_message,
                      ).tr(args: [state.server!.plexName]),
                    ),
                  );

                  context.read<SettingsBloc>().add(SettingsClearCache());
                }

                if (state.status == BlocStatus.failure) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      content: Text(
                        LocaleKeys.clear_tautulli_image_cache_failure_snackbar_message,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onError,
                        ),
                      ).tr(args: [state.server!.plexName]),
                    ),
                  );
                }
              }
            },
            child: PageBody(
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  ListTileGroup(
                    heading: LocaleKeys.connection_details_title.tr(),
                    listTiles: [
                      ServerPrimaryConnectionListTile(server: server),
                      ServerSecondaryConnectionListTile(server: server),
                      ServerDeviceTokenListTile(
                        deviceToken: server.deviceToken,
                      ),
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
                  if (server.customHeaders.isNotEmpty) const Gap(8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    child: const Text(
                      LocaleKeys.add_custom_http_header_title,
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
                  const Gap(8),
                  ListTileGroup(
                    heading: LocaleKeys.other_title.tr(),
                    listTiles: [
                      ServerOpenInBrowserListTile(server: server),
                      CustomListTile(
                        leading: FaIcon(
                          FontAwesomeIcons.eraser,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        title: LocaleKeys.clear_tautulli_image_cache_title.tr(
                          args: [server.plexName],
                        ),
                        subtitle: LocaleKeys.clear_tautulli_image_cache_subtitle.tr(
                          args: [server.plexName],
                        ),
                        onTap: () async {
                          return showDialog(
                            context: context,
                            builder: (_) {
                              return BlocProvider.value(
                                value: context.read<ClearTautulliImageCacheBloc>(),
                                child: ClearTautulliImageCacheDialog(
                                  server: server,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
