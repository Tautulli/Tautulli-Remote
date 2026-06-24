import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../translations/locale_keys.g.dart';
import '../material_style_bottom_sheet_scaffold.dart';

class MaterialStyleTimeRangeBottomSheet extends StatefulWidget {
  final int initialValue;

  const MaterialStyleTimeRangeBottomSheet({
    super.key,
    required this.initialValue,
  });

  @override
  State<MaterialStyleTimeRangeBottomSheet> createState() => _MaterialStyleTimeRangeBottomSheetState();
}

class _MaterialStyleTimeRangeBottomSheetState extends State<MaterialStyleTimeRangeBottomSheet> {
  late int _value;
  final _focusNode = FocusNode();
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _textController.text = ![7, 14, 30].contains(widget.initialValue) ? widget.initialValue.toString() : '90';
  }

  void _selectCustom() {
    final int? parsed = int.tryParse(_textController.text);
    if (parsed != null && parsed > 1) {
      setState(() {
        _value = parsed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialStyleBottomSheetScaffold(
      title: LocaleKeys.time_range_title.tr(),
      leading: TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text(LocaleKeys.cancel_title).tr(),
      ),
      trailing: TextButton(
        onPressed: () => Navigator.of(context).pop(_value),
        child: const Text(LocaleKeys.save_title).tr(),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TimeRangeTile(
              title: '7 ${LocaleKeys.days_title.tr()}',
              selected: _value == 7,
              onTap: () => setState(() => _value = 7),
            ),
            _TimeRangeTile(
              title: '14 ${LocaleKeys.days_title.tr()}',
              selected: _value == 14,
              onTap: () => setState(() => _value = 14),
            ),
            _TimeRangeTile(
              title: '30 ${LocaleKeys.days_title.tr()}',
              selected: _value == 30,
              onTap: () => setState(() => _value = 30),
            ),
            Material(
              color: ElevationOverlay.applySurfaceTint(
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surfaceTint,
                1,
              ),
              child: ListTile(
                title: const Text(LocaleKeys.custom_title).tr(),
                trailing: GestureDetector(
                  onTap: () {
                    _focusNode.requestFocus();
                    _selectCustom();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 50,
                        child: TextField(
                          focusNode: _focusNode,
                          controller: _textController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny(RegExp(r'^0')),
                          ],
                          textAlign: TextAlign.end,
                          decoration: const InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                          ),
                          onTap: () => _selectCustom(),
                          onChanged: (_) => _selectCustom(),
                        ),
                      ),
                      Text(
                        ' ${LocaleKeys.days_title.tr()}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(width: 4),
                      Opacity(
                        opacity: ![7, 14, 30].contains(_value) ? 1 : 0,
                        child: Icon(
                          Icons.check_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  _focusNode.requestFocus();
                  _selectCustom();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}

class _TimeRangeTile extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _TimeRangeTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ElevationOverlay.applySurfaceTint(
        Theme.of(context).colorScheme.surface,
        Theme.of(context).colorScheme.surfaceTint,
        1,
      ),
      child: ListTile(
        title: Text(title),
        trailing: selected
            ? Icon(
                Icons.check_rounded,
                color: Theme.of(context).colorScheme.primary,
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
