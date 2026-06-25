import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:reorderables/reorderables.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/widgets/material/material_style_list_tile.dart';
import '../../../../../../core/widgets/material/material_style_list_tile_chevron.dart';
import '../../../../../../core/widgets/material/material_style_heading.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';
import '../../../pages/material/material_style_server_settings_page.dart';
import '../buttons/material_style_delete_server_button.dart';

class MaterialStyleServersGroup extends StatelessWidget {
  final bool isWizard;

  const MaterialStyleServersGroup({
    super.key,
    this.isWizard = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: MaterialStyleHeading(
                text: LocaleKeys.servers_title.tr(),
              ),
            ),
            const Gap(8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ReorderableColumn(
                mainAxisSize: MainAxisSize.min,
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
                            (server) => MaterialStyleListTile(
                              key: ValueKey(server.tautulliId),
                              sensitive: true,
                              leading: SvgPicture.asset(
                                'assets/logos/logo_flat.svg',
                                colorFilter: ColorFilter.mode(
                                  Theme.of(context).colorScheme.onSurface,
                                  BlendMode.srcIn,
                                ),
                                height: 35,
                              ),
                              title: server.plexName,
                              subtitle: server.primaryActive!
                                  ? server.primaryConnectionAddress
                                  : server.secondaryConnectionAddress,
                              onTap: isWizard
                                  ? null
                                  : () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => MaterialStyleServerSettingsPage(
                                          serverId: server.id!,
                                        ),
                                      ),
                                    ),
                              trailing: isWizard
                                  ? MaterialStyleDeleteServerButton(
                                      isWizard: isWizard,
                                      serverId: server.id!,
                                      server: server,
                                    )
                                  : const MaterialStyleListTileChevron(),
                            ),
                          )
                          .toList()
                    : [],
              ),
            ),
          ],
        );
      },
    );
  }
}
