import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:quiver/strings.dart';

import '../../../../../../core/types/custom_http_header_type.dart';
import '../../../../../../core/widgets/material/material_style_bottom_sheet_scaffold.dart';
import '../../../../../../core/widgets/material/material_style_text_form_field.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../../data/models/custom_header_model.dart';
import '../../../bloc/registration_headers_bloc.dart';
import '../../../bloc/settings_bloc.dart';

class MaterialStyleCustomHttpHeaderBottomSheet extends StatefulWidget {
  final bool forRegistration;
  final String? tautulliId;
  final List<CustomHeaderModel>? currentHeaders;

  const MaterialStyleCustomHttpHeaderBottomSheet({
    super.key,
    required this.forRegistration,
    this.tautulliId,
    this.currentHeaders,
  });

  @override
  State<MaterialStyleCustomHttpHeaderBottomSheet> createState() => _MaterialStyleCustomHttpHeaderBottomSheetState();
}

class _MaterialStyleCustomHttpHeaderBottomSheetState extends State<MaterialStyleCustomHttpHeaderBottomSheet> {
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
    _selectedSegment = _authHeaderExists ? CustomHttpHeaderType.custom : CustomHttpHeaderType.basic;
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
            basicAuth: _selectedSegment == CustomHttpHeaderType.basic,
            previousTitle: null,
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
              previousTitle: null,
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
        title: LocaleKeys.custom_http_headers_title.tr(),
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
            SegmentedButton<CustomHttpHeaderType>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: CustomHttpHeaderType.basic,
                  label: const Text(LocaleKeys.basic_authentication_title).tr(),
                  enabled: !_authHeaderExists,
                ),
                ButtonSegment(
                  value: CustomHttpHeaderType.custom,
                  label: const Text(LocaleKeys.custom_title).tr(),
                ),
              ],
              selected: {_selectedSegment},
              onSelectionChanged: (Set<CustomHttpHeaderType> selection) {
                setState(() {
                  _selectedSegment = selection.first;
                });
                _keyFocus.requestFocus();
              },
            ),
            const Gap(16),
            MaterialStyleTextFormField(
              controller: _keyController,
              focusNode: _keyFocus,
              autofocus: true,
              labelText: _selectedSegment == CustomHttpHeaderType.basic
                  ? LocaleKeys.username_title.tr()
                  : LocaleKeys.header_key_title.tr(),
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
              labelText: _selectedSegment == CustomHttpHeaderType.basic
                  ? LocaleKeys.password_title.tr()
                  : LocaleKeys.header_value_title.tr(),
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
