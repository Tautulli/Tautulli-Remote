import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

import '../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../core/widgets/ios/ios_bottom_sheet_cancel_button.dart';
import '../../../../../core/widgets/ios/ios_bottom_sheet_save_button.dart';
import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../translations/locale_keys.g.dart';

class LibrariesFilterIosBottomSheet extends StatefulWidget {
  final String orderColumn;
  final String orderDir;

  const LibrariesFilterIosBottomSheet({
    super.key,
    required this.orderColumn,
    required this.orderDir,
  });

  @override
  State<LibrariesFilterIosBottomSheet> createState() => _LibrariesFilterIosBottomSheetState();
}

class _LibrariesFilterIosBottomSheetState extends State<LibrariesFilterIosBottomSheet> {
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
    return PageScaffoldCupertino(
      //TODO: Add translation string
      middle: const Text('Sort Libraries'),
      showBackButton: false,
      leading: const IosBottomSheetCancelButton(),
      trailing: IosBottomSheetSaveButton(
        onPressed: () => Navigator.of(context).pop({
          'orderColumn': orderColumn,
          'orderDir': orderDir,
        }),
      ),
      child: SingleChildScrollView(
        child: CustomCupertinoListSection(
          hasLeading: false,
          children: [
            CustomNotchedCupertinoListTile(
              onTap: () => changeSort('section_name'),
              titleText: LocaleKeys.name_title.tr(),
              trailing: orderColumn == 'section_name' ? _activeSortIndicators() : _inactiveSortIndicators(),
            ),
            CustomNotchedCupertinoListTile(
              onTap: () => changeSort('count'),
              //TODO: Needs translation string
              titleText: 'Count',
              trailing: orderColumn == 'count' ? _activeSortIndicators() : _inactiveSortIndicators(),
            ),
            CustomNotchedCupertinoListTile(
              onTap: () => changeSort('duration'),
              //TODO: Needs translation string
              titleText: 'Time',
              trailing: orderColumn == 'duration' ? _activeSortIndicators() : _inactiveSortIndicators(),
            ),
            CustomNotchedCupertinoListTile(
              onTap: () => changeSort('plays'),
              //TODO: Needs translation string
              titleText: 'Plays',
              trailing: orderColumn == 'plays' ? _activeSortIndicators() : _inactiveSortIndicators(),
            ),
          ],
        ),
      ),
    );
  }
}
