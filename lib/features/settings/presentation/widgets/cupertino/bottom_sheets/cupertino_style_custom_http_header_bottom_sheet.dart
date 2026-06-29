import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:quiver/strings.dart';

import '../../../../../../core/types/custom_http_header_type.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_modal_popup_scaffold.dart';
import '../../../../../../core/widgets/cupertino/buttons/cupertino_style_bottom_sheet_cancel_button.dart';
import '../../../../../../core/widgets/cupertino/buttons/cupertino_style_bottom_sheet_save_button.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../../data/models/custom_header_model.dart';
import '../../../bloc/registration_headers_bloc.dart';
import '../../../bloc/settings_bloc.dart';

class CupertinoStyleCustomHttpHeaderBottomSheet extends StatefulWidget {
  final bool forRegistration;
  final String? existingKey;
  final String? existingValue;
  final String? tautulliId;
  final List<CustomHeaderModel>? currentHeaders;

  const CupertinoStyleCustomHttpHeaderBottomSheet({
    super.key,
    required this.forRegistration,
    this.existingKey,
    this.existingValue,
    this.tautulliId,
    this.currentHeaders,
  });

  @override
  State<CupertinoStyleCustomHttpHeaderBottomSheet> createState() => _CupertinoStyleCustomHttpHeaderBottomSheetState();
}

class _CupertinoStyleCustomHttpHeaderBottomSheetState extends State<CupertinoStyleCustomHttpHeaderBottomSheet> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _keyController;
  late FocusNode _keyFocus;
  late TextEditingController _valueController;
  late FocusNode _valueFocus;
  late bool _authHeaderExists;
  late CustomHttpHeaderType _selectedSegment;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _keyController = TextEditingController();
    _keyFocus = FocusNode();
    _valueController = TextEditingController();
    _valueFocus = FocusNode();
    _authHeaderExists = widget.currentHeaders?.indexWhere((header) => header.key == 'Authorization') != -1;

    if (_authHeaderExists) {
      _selectedSegment = CustomHttpHeaderType.custom;
    } else {
      _selectedSegment = CustomHttpHeaderType.basic;
    }

    if (widget.existingKey != null && widget.existingValue != null) {
      _keyController.text = widget.existingKey!;
      _keyController.selection = TextSelection.fromPosition(
        TextPosition(offset: _keyController.text.length),
      );

      _valueController.text = widget.existingValue!;
      _valueController.selection = TextSelection.fromPosition(
        TextPosition(offset: _valueController.text.length),
      );
    }
  }

  @override
  void dispose() {
    _keyController.dispose();
    _keyFocus.dispose();
    _valueController.dispose();
    _valueFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return Form(
      key: _formKey,
      child: CupertinoStyleModalPopupScaffold(
        middleText: LocaleKeys.custom_http_headers_title.tr(),
        leading: const CupertinoStyleBottomSheetCancelButton(),
        trailing: CupertinoStyleBottomSheetSaveButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              if (widget.forRegistration) {
                context.read<RegistrationHeadersBloc>().add(
                  RegistrationHeadersUpdate(
                    title: _keyController.value.text.trim(),
                    subtitle: _valueController.value.text.trim(),
                    basicAuth: _selectedSegment == CustomHttpHeaderType.basic,
                    previousTitle: widget.existingKey,
                  ),
                );
              } else {
                if (widget.tautulliId != null) {
                  context.read<SettingsBloc>().add(
                    SettingsUpdateCustomHeaders(
                      tautulliId: widget.tautulliId!,
                      title: _keyController.value.text.trim(),
                      subtitle: _valueController.value.text.trim(),
                      basicAuth: _selectedSegment == CustomHttpHeaderType.basic,
                      previousTitle: widget.existingKey,
                    ),
                  );
                }
              }

              Navigator.of(context).pop();
            }
          },
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoSlidingSegmentedControl<CustomHttpHeaderType>(
                    groupValue: _selectedSegment,
                    onValueChanged: (CustomHttpHeaderType? value) {
                      if (value != null) {
                        setState(() {
                          _selectedSegment = value;
                        });
                        _keyFocus.requestFocus();
                      }
                    },
                    disabledChildren: _authHeaderExists ? {CustomHttpHeaderType.basic} : {},
                    children: {
                      CustomHttpHeaderType.basic: const Text(LocaleKeys.basic_authentication_title).tr(),
                      CustomHttpHeaderType.custom: const Text(LocaleKeys.custom_title).tr(),
                    },
                  ),
                ],
              ),
              const Gap(20),
              CupertinoFormSection.insetGrouped(
                backgroundColor: Colors.transparent,
                children: [
                  CupertinoTextFormFieldRow(
                    controller: _keyController,
                    focusNode: _keyFocus,
                    autofocus: true,
                    validator: (value) {
                      if (isBlank(value)) {
                        return LocaleKeys.cannot_be_blank_message.tr();
                      }

                      return null;
                    },
                    placeholder: (_selectedSegment == CustomHttpHeaderType.basic)
                        ? LocaleKeys.username_title.tr()
                        : LocaleKeys.header_key_title.tr(),
                  ),
                  CupertinoTextFormFieldRow(
                    controller: _valueController,
                    focusNode: _valueFocus,
                    validator: (value) {
                      if (isBlank(value)) {
                        return LocaleKeys.cannot_be_blank_message.tr();
                      }

                      return null;
                    },
                    placeholder: (_selectedSegment == CustomHttpHeaderType.basic)
                        ? LocaleKeys.password_title.tr()
                        : LocaleKeys.header_value_title.tr(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
