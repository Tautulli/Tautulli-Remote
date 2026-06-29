import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/widgets/cupertino/buttons/cupertino_style_bottom_sheet_cancel_button.dart';
import '../../../../../../core/widgets/cupertino/buttons/cupertino_style_bottom_sheet_save_button.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_modal_popup_scaffold.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_notched_cupertino_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';

class CupertinoStyleLibrariesFilterBottomSheet extends StatefulWidget {
  final String orderColumn;
  final String orderDir;

  const CupertinoStyleLibrariesFilterBottomSheet({
    super.key,
    required this.orderColumn,
    required this.orderDir,
  });

  @override
  State<CupertinoStyleLibrariesFilterBottomSheet> createState() => _CupertinoStyleLibrariesFilterBottomSheetState();
}

class _CupertinoStyleLibrariesFilterBottomSheetState extends State<CupertinoStyleLibrariesFilterBottomSheet> {
  late String orderColumn;
  late String orderDir;

  @override
  void initState() {
    super.initState();
    orderColumn = widget.orderColumn;
    orderDir = widget.orderDir;
  }

  Widget _inactiveSortIndicators() {
    return const Row(
      children: [
        Icon(
          CupertinoIcons.arrow_down,
          color: CupertinoColors.inactiveGray,
        ),
        Gap(4),
        Icon(CupertinoIcons.arrow_up, color: CupertinoColors.inactiveGray),
      ],
    );
  }

  Widget _activeSortIndicators() {
    return Row(
      children: [
        Icon(
          CupertinoIcons.arrow_down,
          color: orderDir == 'asc' ? CupertinoTheme.of(context).primaryColor : CupertinoColors.inactiveGray,
        ),
        const Gap(4),
        Icon(
          CupertinoIcons.arrow_up,
          color: orderDir == 'desc' ? CupertinoTheme.of(context).primaryColor : CupertinoColors.inactiveGray,
        ),
      ],
    );
  }

  void changeSort(String currentColumn) {
    setState(() {
      if (orderColumn == currentColumn) {
        if (orderDir == 'asc') {
          orderDir = 'desc';
        } else {
          orderDir = 'asc';
        }
      } else {
        orderColumn = currentColumn;
        orderDir = 'asc';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return CupertinoStyleModalPopupScaffold(
      middleText: LocaleKeys.sort_libraries_title.tr(),
      leading: const CupertinoStyleBottomSheetCancelButton(),
      trailing: CupertinoStyleBottomSheetSaveButton(
        onPressed: () => Navigator.of(context).pop({
          'orderColumn': orderColumn,
          'orderDir': orderDir,
        }),
      ),
      child: CupertinoStyleListSection(
        hasLeading: false,
        children: [
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () => changeSort('section_name'),
            titleText: LocaleKeys.name_title.tr(),
            trailing: orderColumn == 'section_name' ? _activeSortIndicators() : _inactiveSortIndicators(),
          ),
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () => changeSort('count'),
            titleText: LocaleKeys.count_title.tr(),
            trailing: orderColumn == 'count' ? _activeSortIndicators() : _inactiveSortIndicators(),
          ),
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () => changeSort('duration'),
            titleText: LocaleKeys.time_title.tr(),
            trailing: orderColumn == 'duration' ? _activeSortIndicators() : _inactiveSortIndicators(),
          ),
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () => changeSort('plays'),
            titleText: LocaleKeys.plays_title.tr(),
            trailing: orderColumn == 'plays' ? _activeSortIndicators() : _inactiveSortIndicators(),
          ),
        ],
      ),
    );
  }
}
