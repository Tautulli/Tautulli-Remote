import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/widgets/custom_list_tile.dart';
import '../../../../../core/widgets/list_tile_group.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/clear_tautulli_image_cache_bloc.dart';
import '../../bloc/settings_bloc.dart';
import '../dialogs/clear_app_image_cache_dialog.dart';
import '../dialogs/clear_tautulli_image_cache_dialog.dart';
import '../dialogs/clear_tautulli_image_cache_multiserver_dialog.dart';

class OperationsGroup extends StatelessWidget {
  const OperationsGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTileGroup(
      heading: LocaleKeys.operations_title.tr(),
      listTiles: [
        CustomListTile(
          leading: const FaIcon(FontAwesomeIcons.eraser),
          title: LocaleKeys.clear_app_image_cache_title.tr(),
          subtitle: LocaleKeys.clear_app_image_cache_subtitle.tr(),
          onTap: () async {
            final bool cleared = await showDialog(
              context: context,
              builder: (context) => const ClearAppImageCacheDialog(),
            );

            if (cleared) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    LocaleKeys.clear_app_image_cache_success_snackbar_message,
                  ).tr(),
                ),
              );
            }
          },
        ),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;

            return CustomListTile(
              leading: const FaIcon(FontAwesomeIcons.bomb),
              title: 'Clear Tautulli Image Cache',
              subtitle: 'Delete server cached images',
              onTap: () async {
                return showDialog(
                  context: context,
                  builder: (_) {
                    return BlocProvider.value(
                      value: context.read<ClearTautulliImageCacheBloc>(),
                      child: state.serverList.length > 1
                          ? const ClearTautulliImageCacheMultiserverDialog()
                          : const ClearTautulliImageCacheDialog(),
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}
