import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:reorderables/reorderables.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../core/widgets/heading.dart';
import '../bloc/settings_bloc.dart';
import '../pages/server_settings_page.dart';
import 'settings_list_tile.dart';

class ServersGroup extends StatelessWidget {
  const ServersGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Heading(
                text: 'Servers',
              ),
            ),
            const Gap(8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: ReorderableColumn(
                mainAxisSize: MainAxisSize.min,
                onReorder: (oldIndex, newIndex) {},
                children: state is SettingsSuccess
                    ? state.serverList
                        .map(
                          (server) => SettingsListTile(
                            key: ValueKey(server.tautulliId),
                            sensitive: true,
                            leading: WebsafeSvg.asset(
                              'assets/logos/logo_flat.svg',
                              color: Theme.of(context).colorScheme.tertiary,
                              height: 35,
                            ),
                            title: server.plexName,
                            subtitle: server.primaryActive!
                                ? server.primaryConnectionAddress
                                : server.secondaryConnectionAddress,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ServerSettingsPage(),
                              ),
                            ),
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
