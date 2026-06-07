import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_modal_popup_scaffold.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_notched_cupertino_list_tile.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_bottom_sheet_cancel_button.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/logging_bloc.dart';
import '../../bloc/logging_export_bloc.dart';
import 'cupertino_style_clear_logging_dialog.dart';

class CupertinoStyleLoggingActionsBottomSheet extends StatelessWidget {
  const CupertinoStyleLoggingActionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final LoggingBloc loggingBloc = context.read<LoggingBloc>();

    return CupertinoStyleModalPopupScaffold(
      leading: const CupertinoStyleBottomSheetCancelButton(),
      //TODO: Translation string
      middleText: 'Logging Actions',
      child: CupertinoStyleListSection(
        children: [
          CupertinoStyleNotchedCupertinoListTile(
            leading: Icon(
              CupertinoIcons.arrow_down_doc_fill,
              color: ThemeHelper.cupertinoListTileIconColor(),
            ),
            titleText: LocaleKeys.logs_export_menu_item.tr(),
            onTap: () {
              Navigator.of(context).pop();

              context.read<LoggingExportBloc>().add(
                LoggingExportStart(
                  context: context,
                  loggingBloc: context.read<LoggingBloc>(),
                ),
              );
            },
          ),
          CupertinoStyleNotchedCupertinoListTile(
            leading: Icon(
              CupertinoIcons.clear_circled_solid,
              color: ThemeHelper.cupertinoListTileIconColor(),
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
