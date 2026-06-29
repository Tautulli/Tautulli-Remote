import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:quiver/strings.dart';

import '../../../../../../core/widgets/material/material_style_bottom_sheet_scaffold.dart';
import '../../../../../../core/widgets/material/material_style_text_form_field.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/registration_headers_bloc.dart';
import '../../../bloc/settings_bloc.dart';

class MaterialStyleEditCustomHttpHeaderBottomSheet extends StatefulWidget {
  final bool forRegistration;
  final String existingKey;
  final String existingValue;
  final String? tautulliId;

  const MaterialStyleEditCustomHttpHeaderBottomSheet({
    super.key,
    required this.forRegistration,
    required this.existingKey,
    required this.existingValue,
    this.tautulliId,
  });

  @override
  State<MaterialStyleEditCustomHttpHeaderBottomSheet> createState() =>
      _MaterialStyleEditCustomHttpHeaderBottomSheetState();
}

class _MaterialStyleEditCustomHttpHeaderBottomSheetState extends State<MaterialStyleEditCustomHttpHeaderBottomSheet> {
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

    _keyController.selection = TextSelection.fromPosition(TextPosition(offset: _keyController.text.length));
    _valueController.selection = TextSelection.fromPosition(TextPosition(offset: _valueController.text.length));
  }

  @override
  void dispose() {
    _keyController.dispose();
    _keyFocus.dispose();
    _valueController.dispose();
    _valueFocus.dispose();
    super.dispose();
  }

  void _save() {
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
  }

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return Form(
      key: _formKey,
      child: MaterialStyleBottomSheetScaffold(
        title: _isBasicAuth
            ? LocaleKeys.edit_basic_authentication_header_title.tr()
            : LocaleKeys.edit_custom_header_title.tr(),
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(LocaleKeys.cancel_title).tr(),
        ),
        trailing: TextButton(
          onPressed: _save,
          child: const Text(LocaleKeys.save_title).tr(),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MaterialStyleTextFormField(
              controller: _keyController,
              focusNode: _keyFocus,
              autofocus: true,
              labelText: _isBasicAuth ? LocaleKeys.username_title.tr() : LocaleKeys.header_key_title.tr(),
              validator: (value) {
                if (isBlank(value)) {
                  return LocaleKeys.cannot_be_blank_message.tr();
                }
                return null;
              },
            ),
            const Gap(16),
            MaterialStyleTextFormField(
              controller: _valueController,
              focusNode: _valueFocus,
              labelText: _isBasicAuth ? LocaleKeys.password_title.tr() : LocaleKeys.header_value_title.tr(),
              validator: (value) {
                if (isBlank(value)) {
                  return LocaleKeys.cannot_be_blank_message.tr();
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
