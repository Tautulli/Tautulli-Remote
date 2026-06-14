import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/widgets/material/material_style_list_tile.dart';
import '../../../../../core/widgets/material/material_style_list_tile_group.dart';
import '../../../../../core/widgets/material/material_style_page_body.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/clear_tautulli_image_cache_bloc.dart';
import '../../bloc/settings_bloc.dart';
import '../../widgets/material/buttons/material_style_delete_server_button.dart';
import '../../widgets/material/dialogs/material_style_clear_tautulli_image_cache_dialog.dart';
import '../../widgets/material/dialogs/material_style_custom_header_type_dialog.dart';
import '../../widgets/material/list_tiles/material_style_custom_header_list_tile.dart';
import '../../widgets/material/list_tiles/material_style_server_device_token_list_tile.dart';
import '../../widgets/material/list_tiles/material_style_server_open_in_browser_list_tile.dart';
import '../../widgets/material/list_tiles/material_style_server_primary_connection_list_tile.dart';
import '../../widgets/material/list_tiles/material_style_server_secondary_connection_list_tile.dart';

class MaterialStyleServerSettingsPage extends StatelessWidget {
  final int serverId;

  const MaterialStyleServerSettingsPage({
    super.key,
    required this.serverId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ClearTautulliImageCacheBloc>(),
      child: MaterialStyleServerSettingsView(
        serverId: serverId,
      ),
    );
  }
}

class MaterialStyleServerSettingsView extends StatelessWidget {
  final int serverId;

  const MaterialStyleServerSettingsView({
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
        final sortedHeaders = [...server.customHeaders];
        sortedHeaders.sort((a, b) => a.key.compareTo(b.key));
        final index = sortedHeaders.indexWhere(
          (element) => element.key == 'Authorization',
        );
        if (index != -1) {
          final authHeader = sortedHeaders.removeAt(index);
          sortedHeaders.insert(0, authHeader);
        }

        return Scaffold(
          appBar: AppBar(
            forceMaterialTransparency: true,
            title: Text(server.plexName),
            actions: [
              MaterialStyleDeleteServerButton(
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
            child: MaterialStylePageBody(
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  MaterialStyleListTileGroup(
                    heading: LocaleKeys.connection_details_title.tr(),
                    listTiles: [
                      MaterialStyleServerPrimaryConnectionListTile(server: server),
                      MaterialStyleServerSecondaryConnectionListTile(server: server),
                      MaterialStyleServerDeviceTokenListTile(
                        deviceToken: server.deviceToken,
                      ),
                    ],
                  ),
                  const Gap(8),
                  MaterialStyleListTileGroup(
                    heading: LocaleKeys.custom_http_headers_title.tr(),
                    listTiles: sortedHeaders
                        .map(
                          (header) => MaterialStyleCustomHeaderListTile(
                            forRegistration: false,
                            tautulliId: server.tautulliId,
                            title: header.key,
                            subtitle: header.value,
                          ),
                        )
                        .toList(),
                  ),
                  if (sortedHeaders.isNotEmpty) const Gap(8),
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
                      builder: (context) => MaterialStyleCustomHeaderTypeDialog(
                        forRegistration: false,
                        tautulliId: server.tautulliId,
                        currentHeaders: server.customHeaders,
                      ),
                    ),
                  ),
                  const Gap(8),
                  MaterialStyleListTileGroup(
                    heading: LocaleKeys.other_title.tr(),
                    listTiles: [
                      MaterialStyleServerOpenInBrowserListTile(server: server),
                      MaterialStyleListTile(
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
                                child: MaterialStyleClearTautulliImageCacheDialog(
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
