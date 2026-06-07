import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reorderables/reorderables.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_notched_cupertino_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';
import '../../../pages/cupertino/cupertino_style_server_settings_page.dart';
import '../cupertino_style_delete_server_button.dart';

class CupertinoStyleServersGroup extends StatelessWidget {
  final bool isWizard;

  const CupertinoStyleServersGroup({
    super.key,
    this.isWizard = false,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoStyleListSection(
      margin: isWizard ? EdgeInsets.zero : null,
      headerText: isWizard ? null : LocaleKeys.servers_title.tr(),
      children: [
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return ReorderableColumn(
              onReorder: (oldIndex, newIndex) {
                if (state is SettingsSuccess) {
                  final int movedServerId = state.serverList[oldIndex].id!;

                  context.read<SettingsBloc>().add(
                    SettingsUpdateServerSort(
                      serverId: movedServerId,
                      oldIndex: oldIndex,
                      newIndex: newIndex,
                    ),
                  );
                }
              },
              children: state is SettingsSuccess
                  ? state.serverList
                        .map(
                          (server) => CupertinoStyleNotchedCupertinoListTile(
                            sensitive: true,
                            key: ValueKey(server.tautulliId),
                            leading: WebsafeSvg.asset(
                              'assets/logos/logo_flat.svg',
                              colorFilter: ColorFilter.mode(
                                ThemeHelper.cupertinoListTileIconColor(),
                                BlendMode.srcIn,
                              ),
                            ),
                            titleText: server.plexName,
                            subtitleText:
                                '${server.primaryActive! ? server.primaryConnectionAddress : server.secondaryConnectionAddress}',
                            onTap: isWizard
                                ? null
                                : () => Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (context) => CupertinoStyleServerSettingsPage(
                                        serverId: server.id!,
                                        previousPageTitle: LocaleKeys.settings_title.tr(),
                                      ),
                                    ),
                                  ),
                            trailing: isWizard
                                ? CupertinoStyleDeleteServerButton(
                                    serverId: server.id!,
                                    server: server,
                                  )
                                : const CupertinoListTileChevron(),
                          ),
                        )
                        .toList()
                  : [],
            );
          },
        ),
      ],
    );
  }
}
