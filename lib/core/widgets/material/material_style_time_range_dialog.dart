import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:quiver/strings.dart';

import '../../../translations/locale_keys.g.dart';

class MaterialStyleTimeRangeDialog extends StatefulWidget {
  const MaterialStyleTimeRangeDialog({super.key});

  @override
  State<MaterialStyleTimeRangeDialog> createState() => _MaterialStyleTimeRangeDialogState();
}

class _MaterialStyleTimeRangeDialogState extends State<MaterialStyleTimeRangeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(LocaleKeys.custom_time_range_title).tr(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _textController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                //TODO: Shouldn't display time suggestion on statistics page
                hintText: LocaleKeys.enter_time_range_in_days_message.tr(),
              ),
              validator: (value) {
                if (isBlank(value)) {
                  return LocaleKeys.cannot_be_blank_message.tr();
                } else {
                  try {
                    final timeRange = int.parse(value!);

                    if (timeRange < 2) {
                      return LocaleKeys.integer_larger_than_1_message.tr();
                    } else {
                      return null;
                    }
                  } catch (e) {
                    return LocaleKeys.enter_an_integer_message.tr();
                  }
                }
              },
            ),
          ),
          const Gap(8),
          Text(
            LocaleKeys.custom_time_range_dialog_content,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ).tr(),
        ],
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(LocaleKeys.close_title).tr(),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () {
            if (_formKey.currentState != null && _formKey.currentState!.validate()) {
              Navigator.of(context).pop(int.parse(_textController.value.text));
            }
          },
          child: const Text(LocaleKeys.save_title).tr(),
        ),
      ],
    );
  }
}
