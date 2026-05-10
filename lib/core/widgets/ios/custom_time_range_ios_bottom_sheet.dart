import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../translations/locale_keys.g.dart';
import 'cupertino_card.dart';
import 'custom_cupertino_list_section.dart';
import 'ios_bottom_sheet_cancel_button.dart';
import 'ios_bottom_sheet_save_button.dart';
import 'page_scaffold_cupertino.dart';

class CustomTimeRangeIosBottomSheet extends StatelessWidget {
  final int initialValue;
  final bool showRangeSuggestion;

  const CustomTimeRangeIosBottomSheet({
    super.key,
    required this.initialValue,
    this.showRangeSuggestion = false,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController();

    controller.text = initialValue.toString();

    return Form(
      key: formKey,
      child: PageScaffoldCupertino(
        showBackButton: false,
        //TODO: Needs translation string
        middle: const Text('Custom Value'),
        leading: const IosBottomSheetCancelButton(),
        trailing: IosBottomSheetSaveButton(
          onPressed: () {
            if (formKey.currentState != null && formKey.currentState!.validate()) {
              Navigator.of(context).pop(int.parse(controller.text));
            }
          },
        ),
        child: Column(
          children: [
            CustomCupertinoListSection(
              hasLeading: false,
              children: [
                CupertinoTextFormFieldRow(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  validator: (value) {
                    if (value != null) {
                      int? valueInt = int.tryParse(value);
                      if (valueInt != null) {
                        return null;
                      }
                    }
                    return LocaleKeys.enter_an_integer_message.tr();
                  },
                  placeholder: LocaleKeys.enter_time_range_in_days_message.tr(),
                ),
              ],
            ),
            if (showRangeSuggestion)
              CupertinoCard(
                horizontalPadding: 20,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(LocaleKeys.custom_time_range_dialog_content).tr(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
