import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/clear_tautulli_image_cache_bloc.dart';
import '../../bloc/settings_bloc.dart';
import '../../widgets/ios/bottom_sheets/custom_http_header_ios_bottom_sheet.dart';
import '../../widgets/ios/delete_server_ios_button.dart';
import '../../widgets/ios/dialogs/clear_tautulli_image_cache_ios_dialog.dart';
import '../../widgets/ios/list_tiles/custom_header_ios_list_tile.dart';
import '../../widgets/ios/list_tiles/server_device_token_ios_list_tile.dart';
import '../../widgets/ios/list_tiles/server_open_in_browser_ios_list_tile.dart';
import '../../widgets/ios/list_tiles/server_primary_connection_ios_list_tile.dart';
import '../../widgets/ios/list_tiles/server_secondary_connection_ios_list_tile.dart';

class ServerSettingsIosPage extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;
  final int serverId;

  const ServerSettingsIosPage({
    super.key,
    this.showBackButton = true,
    this.previousPageTitle,
    required this.serverId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ClearTautulliImageCacheBloc>(),
      child: ServerSettingsIosView(
        showBackButton: showBackButton,
        serverId: serverId,
        previousPageTitle: previousPageTitle,
      ),
    );
  }
}

class ServerSettingsIosView extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;
  final int serverId;

  const ServerSettingsIosView({
    super.key,
    required this.showBackButton,
    this.previousPageTitle,
    required this.serverId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is SettingsSuccess) {
          final serverExists = state.serverList.any((s) => s.id == serverId);

          if (!serverExists && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        }
      },
      builder: (context, state) {
        state as SettingsSuccess;

        // Display something after the state updates while we wait for the listener
        final serverExists = state.serverList.any((s) => s.id == serverId);
        if (!serverExists) return const SizedBox();

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

        return PageScaffoldCupertino(
          showBackButton: showBackButton,
          previousPageTitle: previousPageTitle,
          middle: Text(server.plexName),
          trailing: DeleteServerIosButton(
            serverId: serverId,
            server: server,
          ),
          child: BlocListener<ClearTautulliImageCacheBloc, ClearTautulliImageCacheState>(
            listener: (context, state) {
              if (state.server != null) {
                if (state.status == BlocStatus.success) {
                  Fluttertoast.showToast(
                    toastLength: Toast.LENGTH_LONG,
                    msg: LocaleKeys.clear_tautulli_image_cache_success_snackbar_message.tr(
                      args: [state.server!.plexName],
                    ),
                  );

                  context.read<SettingsBloc>().add(SettingsClearCache());
                }

                if (state.status == BlocStatus.failure) {
                  Fluttertoast.showToast(
                    backgroundColor: CupertinoColors.destructiveRed,
                    textColor: CupertinoColors.black,
                    toastLength: Toast.LENGTH_LONG,
                    msg: LocaleKeys.clear_tautulli_image_cache_failure_snackbar_message.tr(
                      args: [state.server!.plexName],
                    ),
                  );
                }
              }
            },
            child: ListView(
              children: [
                CustomCupertinoListSection(
                  headerText: LocaleKeys.connection_details_title.tr(),
                  children: [
                    ServerPrimaryConnectionIosListTile(server: server),
                    ServerSecondaryConnectionIosListTile(server: server),
                    ServerDeviceTokenIosListTile(deviceToken: server.deviceToken),
                  ],
                ),
                CustomCupertinoListSection(
                  headerText: LocaleKeys.custom_http_headers_title.tr(),
                  children: server.customHeaders
                      .map(
                        (header) => CustomHeaderIosListTile(
                          forRegistration: false,
                          title: header.key,
                          subtitle: header.value,
                          tautulliId: server.tautulliId,
                        ),
                      )
                      .toList(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CupertinoButton.filled(
                    child: const Text(LocaleKeys.add_custom_http_header_title).tr(),
                    onPressed: () => showCupertinoModalPopup(
                      context: context,
                      builder: (context) => CustomHttpHeaderIosBottomSheet(
                        forRegistration: false,
                        tautulliId: server.tautulliId,
                        currentHeaders: server.customHeaders,
                      ),
                    ),
                  ),
                ),
                CustomCupertinoListSection(
                  headerText: LocaleKeys.other_title.tr(),
                  children: [
                    ServerOpenInBrowserIosListTile(server: server),
                    CustomNotchedCupertinoListTile(
                      titleText: LocaleKeys.clear_tautulli_image_cache_title.tr(args: [server.plexName]),
                      subtitleText: LocaleKeys.clear_tautulli_image_cache_subtitle.tr(args: [server.plexName]),
                      leading: FaIcon(
                        FontAwesomeIcons.eraser,
                        color: ThemeHelper.cupertinoListTileIconColor(),
                        size: 21.3,
                      ),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () async => showCupertinoDialog(
                        context: context,
                        builder: (_) {
                          return BlocProvider.value(
                            value: context.read<ClearTautulliImageCacheBloc>(),
                            child: ClearTautulliImageCacheIosDialog(
                              server: server,
                            ),
                          );
                        },
                      ),
                    ),
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
