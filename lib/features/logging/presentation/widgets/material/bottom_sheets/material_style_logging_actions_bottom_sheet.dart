import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/widgets/material/material_style_bottom_sheet_scaffold.dart';
import '../../../../../../core/widgets/material/material_style_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/logging_bloc.dart';
import '../../../bloc/logging_export_bloc.dart';
import '../dialogs/material_style_clear_logging_dialog.dart';

class MaterialStyleLoggingActionsBottomSheet extends StatelessWidget {
  const MaterialStyleLoggingActionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    final LoggingBloc loggingBloc = context.read<LoggingBloc>();

    return MaterialStyleBottomSheetScaffold(
      title: LocaleKeys.logging_actions_title.tr(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MaterialStyleListTile(
              leading: FaIcon(
                FontAwesomeIcons.fileExport,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: LocaleKeys.logs_export_menu_item.tr(),
              onTap: () {
                final exportBloc = context.read<LoggingExportBloc>();
                final box = context.findRenderObject() as RenderBox?;
                Rect? sharePositionOrigin;
                if (box != null) {
                  sharePositionOrigin = box.size.width > 442.0
                      ? Rect.fromLTRB(0, box.size.height - 1, box.size.width, box.size.height)
                      : box.localToGlobal(Offset.zero) & box.size;
                }
                Navigator.of(context).pop();
                exportBloc.add(
                  LoggingExportStart(
                    sharePositionOrigin: sharePositionOrigin,
                    loggingBloc: loggingBloc,
                  ),
                );
              },
            ),
            MaterialStyleListTile(
              leading: FaIcon(
                FontAwesomeIcons.solidCircleXmark,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: LocaleKeys.logs_clear_menu_item.tr(),
              onTap: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: loggingBloc,
                    child: const MaterialStyleClearLoggingDialog(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
