import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/widgets/custom_list_tile.dart';
import '../../../../../core/widgets/list_tile_group.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../dialogs/clear_cache_dialog.dart';

class OperationsGroup extends StatelessWidget {
  const OperationsGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTileGroup(
      heading: LocaleKeys.operations_title.tr(),
      listTiles: [
        CustomListTile(
          leading: const FaIcon(FontAwesomeIcons.eraser),
          title: LocaleKeys.clear_image_cache_title.tr(),
          subtitle: LocaleKeys.clear_image_cache_subtitle.tr(),
          onTap: () async {
            final bool cleared = await showDialog(
              context: context,
              builder: (context) => const ClearCacheDialog(),
            );

            if (cleared) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    LocaleKeys.clear_image_cache_snackbar_message,
                  ).tr(),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
