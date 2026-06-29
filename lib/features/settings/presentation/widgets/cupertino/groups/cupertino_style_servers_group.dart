import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reorderables/reorderables.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_notched_cupertino_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';
import '../../../pages/cupertino/cupertino_style_server_settings_page.dart';
import '../buttons/cupertino_style_delete_server_button.dart';

class CupertinoStyleServersGroup extends StatelessWidget {
  final bool isWizard;

  const CupertinoStyleServersGroup({
    super.key,
    this.isWizard = false,
  });

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return CupertinoStyleListSection(
      // Transparent decoration: the section has a single child (BlocBuilder), so
      // CupertinoListSection renders no separators and no separator inset areas.
      // Tiles provide their own backgrounds, allowing the placeholder opacity to
      // show the darker scaffold color behind the drop target position.
      decoration: const BoxDecoration(),
      margin: isWizard ? EdgeInsets.zero : null,
      headerText: isWizard ? null : LocaleKeys.servers_title.tr(),
      children: [
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return ReorderableColumn(
              // Reorderables' default feedback wraps in Material(elevation:6) + Card,
              // which is correct for Material style but wrong here — it applies Material
              // theming and rectangular corners instead of squircle.
              buildDraggableFeedback: (context, constraints, child) {
                return DecoratedBox(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x40000000),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRSuperellipse(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: ConstrainedBox(constraints: constraints, child: child),
                  ),
                );
              },
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
                            leading: SvgPicture.asset(
                              'assets/logos/logo_flat.svg',
                              colorFilter: const ColorFilter.mode(
                                ThemeHelper.cupertinoListTileIconColor,
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
