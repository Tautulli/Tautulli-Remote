import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import 'custom_cupertino_list_section.dart';
import 'custom_notched_cupertino_list_tile.dart';
import 'custom_time_range_ios_bottom_sheet.dart';
import 'ios_bottom_sheet_cancel_button.dart';
import 'page_scaffold_cupertino.dart';
import '../../../translations/locale_keys.g.dart';

class TimeRangeIosBottomSheet extends StatefulWidget {
  final int initialValue;

  const TimeRangeIosBottomSheet({
    super.key,
    required this.initialValue,
  });

  @override
  State<TimeRangeIosBottomSheet> createState() => _TimeRangeIosBottomSheetState();
}

class _TimeRangeIosBottomSheetState extends State<TimeRangeIosBottomSheet> {
  late int _customValue;

  @override
  void initState() {
    super.initState();

    if (![7, 14, 30].contains(widget.initialValue)) {
      _customValue = widget.initialValue;
    } else {
      _customValue = 90;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffoldCupertino(
      showBackButton: false,
      //TODO: Needs translation string
      middle: const Text(LocaleKeys.time_range_title).tr(),
      leading: const IosBottomSheetCancelButton(),
      child: Column(
        children: [
          CustomCupertinoListSection(
            hasLeading: false,
            children: [
              CustomNotchedCupertinoListTile(
                onTap: () {
                  Navigator.of(context).pop(7);
                },
                titleText: '7 ${LocaleKeys.days_title.tr()}',
                trailing: widget.initialValue == 7 ? const Icon(CupertinoIcons.checkmark_alt) : null,
              ),
              CustomNotchedCupertinoListTile(
                onTap: () {
                  Navigator.of(context).pop(14);
                },
                titleText: '14 ${LocaleKeys.days_title.tr()}',
                trailing: widget.initialValue == 14 ? const Icon(CupertinoIcons.checkmark_alt) : null,
              ),
              CustomNotchedCupertinoListTile(
                onTap: () {
                  Navigator.of(context).pop(30);
                },
                titleText: '30 ${LocaleKeys.days_title.tr()}',
                trailing: widget.initialValue == 30 ? const Icon(CupertinoIcons.checkmark_alt) : null,
              ),
              CustomNotchedCupertinoListTile(
                onTap: () {
                  Navigator.of(context).pop(_customValue);
                },
                titleText: LocaleKeys.custom_title.tr(),
                trailing: ![7, 14, 30].contains(widget.initialValue) ? const Icon(CupertinoIcons.checkmark_alt) : null,
              ),
            ],
          ),
          CustomCupertinoListSection(
            hasLeading: false,
            children: [
              CustomNotchedCupertinoListTile(
                onTap: () async {
                  final result = await showCupertinoSheet(
                    context: context,
                    builder: (_) => CustomTimeRangeIosBottomSheet(
                      initialValue: _customValue,
                    ),
                  );

                  if (result != null) {
                    //TODO: Save the custom time range
                    setState(() {
                      _customValue = result;
                    });
                  }
                },
                //TODO: Needs translation string
                titleText: 'Custom Value',
                additionalInfo: Text('$_customValue ${LocaleKeys.days_title.tr()}'),
                trailing: const CupertinoListTileChevron(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
