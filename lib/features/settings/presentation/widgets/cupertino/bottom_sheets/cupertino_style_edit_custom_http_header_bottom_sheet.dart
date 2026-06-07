import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/strings.dart';

import '../../../../../../core/widgets/cupertino/cupertino_style_modal_popup_scaffold.dart';
import '../../../../../../core/widgets/cupertino/buttons/cupertino_style_bottom_sheet_cancel_button.dart';
import '../../../../../../core/widgets/cupertino/buttons/cupertino_style_bottom_sheet_save_button.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/registration_headers_bloc.dart';
import '../../../bloc/settings_bloc.dart';

class CupertinoStyleEditCustomHttpHeaderBottomSheet extends StatefulWidget {
  final bool forRegistration;
  final String existingKey;
  final String existingValue;
  final String? tautulliId;

  const CupertinoStyleEditCustomHttpHeaderBottomSheet({
    super.key,
    required this.forRegistration,
    required this.existingKey,
    required this.existingValue,
    this.tautulliId,
  });

  @override
  State<CupertinoStyleEditCustomHttpHeaderBottomSheet> createState() =>
      _CupertinoStyleEditCustomHttpHeaderBottomSheetState();
}

class _CupertinoStyleEditCustomHttpHeaderBottomSheetState extends State<CupertinoStyleEditCustomHttpHeaderBottomSheet> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _keyController;
  late FocusNode _keyFocus;
  late TextEditingController _valueController;
  late FocusNode _valueFocus;
  late bool _isBasicAuth;
  List<String>? _basicAuthCreds;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();
    _keyController = TextEditingController();
    _keyFocus = FocusNode();
    _valueController = TextEditingController();
    _valueFocus = FocusNode();
    _isBasicAuth = widget.existingKey == 'Authorization' && widget.existingValue.startsWith('Basic ');

    if (_isBasicAuth) {
      _basicAuthCreds = utf8.decode(base64Decode(widget.existingValue.substring(6))).split(':');

      _keyController.text = _basicAuthCreds![0];
      _valueController.text = _basicAuthCreds![1];
    } else {
      _keyController.text = widget.existingKey;
      _valueController.text = widget.existingValue;
    }

    _keyController.selection = TextSelection.fromPosition(
      TextPosition(offset: _keyController.text.length),
    );

    _valueController.selection = TextSelection.fromPosition(
      TextPosition(offset: _valueController.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: CupertinoStyleModalPopupScaffold(
        //TODO: Add translations
        middleText: _isBasicAuth ? 'Edit Basic Authentication Header' : 'Edit Custom Header',
        leading: const CupertinoStyleBottomSheetCancelButton(),
        trailing: CupertinoStyleBottomSheetSaveButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              if (widget.forRegistration) {
                context.read<RegistrationHeadersBloc>().add(
                  RegistrationHeadersUpdate(
                    title: _keyController.value.text.trim(),
                    subtitle: _valueController.value.text.trim(),
                    basicAuth: _isBasicAuth,
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
                      basicAuth: _isBasicAuth,
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
          padding: const EdgeInsetsGeometry.only(top: 20),
          child: CupertinoFormSection.insetGrouped(
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
                placeholder: (_isBasicAuth) ? LocaleKeys.username_title.tr() : LocaleKeys.header_key_title.tr(),
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
                placeholder: (_isBasicAuth) ? LocaleKeys.password_title.tr() : LocaleKeys.header_value_title.tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
