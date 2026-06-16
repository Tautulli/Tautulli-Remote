import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/widgets/cupertino/buttons/cupertino_style_bottom_sheet_cancel_button.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_modal_popup_scaffold.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_notched_cupertino_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/logging_bloc.dart';
import '../../../bloc/logging_export_bloc.dart';
import '../dialogs/cupertino_style_clear_logging_dialog.dart';

class CupertinoStyleLoggingActionsBottomSheet extends StatelessWidget {
  const CupertinoStyleLoggingActionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final LoggingBloc loggingBloc = context.read<LoggingBloc>();

    return CupertinoStyleModalPopupScaffold(
      leading: const CupertinoStyleBottomSheetCancelButton(),
      middleText: LocaleKeys.logging_actions_title.tr(),
      child: CupertinoStyleListSection(
        children: [
          CupertinoStyleNotchedCupertinoListTile(
            leading: const Icon(
              CupertinoIcons.arrow_down_doc_fill,
              color: ThemeHelper.cupertinoListTileIconColor,
            ),
            titleText: LocaleKeys.logs_export_menu_item.tr(),
            onTap: () {
              final exportBloc = context.read<LoggingExportBloc>();
              final loggingBloc = context.read<LoggingBloc>();
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
          CupertinoStyleNotchedCupertinoListTile(
            leading: const Icon(
              CupertinoIcons.clear_circled_solid,
              color: ThemeHelper.cupertinoListTileIconColor,
            ),
            titleText: LocaleKeys.logs_clear_menu_item.tr(),
            onTap: () {
              Navigator.of(context).pop();

              showCupertinoDialog(
                context: context,
                builder: (context) => BlocProvider.value(
                  value: loggingBloc,
                  child: const CupertinoStyleClearLoggingDialog(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
