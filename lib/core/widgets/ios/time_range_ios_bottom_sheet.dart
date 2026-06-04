import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import '../../../translations/locale_keys.g.dart';
import 'cupertino_modal_popup_scaffold.dart';
import 'custom_cupertino_list_section.dart';
import 'custom_notched_cupertino_list_tile.dart';
import 'ios_bottom_sheet_cancel_button.dart';
import 'ios_bottom_sheet_save_button.dart';

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
  late int _value;
  final _focusNode = FocusNode();
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _value = widget.initialValue;

    if (![7, 14, 30].contains(widget.initialValue)) {
      _textController.text = widget.initialValue.toString();
    } else {
      _textController.text = '90';
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoModalPopupScaffold(
      middleText: LocaleKeys.time_range_title.tr(),
      leading: const IosBottomSheetCancelButton(),
      trailing: IosBottomSheetSaveButton(
        onPressed: () {
          Navigator.of(context).pop(_value);
        },
      ),
      child: Column(
        children: [
          CustomCupertinoListSection(
            hasLeading: false,
            children: [
              CustomNotchedCupertinoListTile(
                onTap: () {
                  setState(() {
                    _value = 7;
                  });
                },
                titleText: '7 ${LocaleKeys.days_title.tr()}',
                trailing: _value == 7 ? const Icon(CupertinoIcons.checkmark_alt) : null,
              ),
              CustomNotchedCupertinoListTile(
                onTap: () {
                  setState(() {
                    _value = 14;
                  });
                },
                titleText: '14 ${LocaleKeys.days_title.tr()}',
                trailing: _value == 14 ? const Icon(CupertinoIcons.checkmark_alt) : null,
              ),
              CustomNotchedCupertinoListTile(
                onTap: () {
                  setState(() {
                    _value = 30;
                  });
                },
                titleText: '30 ${LocaleKeys.days_title.tr()}',
                trailing: _value == 30 ? const Icon(CupertinoIcons.checkmark_alt) : null,
              ),
              CustomNotchedCupertinoListTile(
                onTap: () => _selectCustom(),
                titleText: LocaleKeys.custom_title.tr(),
                trailing: GestureDetector(
                  onTap: () {
                    _focusNode.requestFocus();
                    _selectCustom();
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                        child: CupertinoTextField(
                          focusNode: _focusNode,
                          controller: _textController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny(RegExp(r'^0')),
                          ],
                          textAlign: TextAlign.end,
                          padding: EdgeInsetsGeometry.zero,
                          decoration: null,
                          onTap: () => _selectCustom(),
                          onChanged: (value) {
                            //TODO: Save custom value
                            _selectCustom();
                          },
                        ),
                      ),
                      Row(
                        children: [
                          const Text(LocaleKeys.days_title).tr(),
                          const Gap(4),
                          Opacity(
                            opacity: ![7, 14, 30].contains(_value) ? 1 : 0,
                            child: const Icon(CupertinoIcons.checkmark_alt),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _selectCustom() {
    final int? parsed = int.tryParse(_textController.text);
    if (parsed != null) {
      setState(() {
        _value = parsed;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
