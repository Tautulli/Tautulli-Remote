import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:quiver/strings.dart';

import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/registration_headers_bloc.dart';
import '../../bloc/settings_bloc.dart';

enum CustomHeaderType {
  basicAuth,
  custom,
}

class CustomHeaderConfigDialog extends StatefulWidget {
  final CustomHeaderType headerType;
  final bool forRegistration;
  final String? existingKey;
  final String? existingValue;
  final String? tautulliId;
  // final List<CustomHeaderModel>? currentHeaders;

  const CustomHeaderConfigDialog({
    super.key,
    required this.headerType,
    required this.forRegistration,
    this.existingKey,
    this.existingValue,
    this.tautulliId,
    // this.currentHeaders,
  });

  @override
  State<CustomHeaderConfigDialog> createState() => _CustomHeaderConfigDialogState();
}

class _CustomHeaderConfigDialogState extends State<CustomHeaderConfigDialog> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _keyController;
  late FocusNode _keyFocus;
  late bool _keyValid;
  late TextEditingController _valueController;
  late FocusNode _valueFocus;
  late bool _valueValid;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _keyController = TextEditingController();
    _keyFocus = FocusNode();
    _keyValid = true;
    _valueController = TextEditingController();
    _valueFocus = FocusNode();
    _valueValid = true;

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
    return AlertDialog(
      title: Row(
        children: [
          FaIcon(
            widget.headerType == CustomHeaderType.basicAuth
                ? FontAwesomeIcons.solidAddressCard
                : FontAwesomeIcons.addressCard,
          ),
          const Gap(12),
          Expanded(
            child: Text(
              widget.headerType == CustomHeaderType.basicAuth
                  ? LocaleKeys.basic_authentication_title.tr()
                  : LocaleKeys.custom_title.tr(),
            ),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _keyController,
              focusNode: _keyFocus,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: widget.headerType == CustomHeaderType.basicAuth
                    ? '${LocaleKeys.username_title.tr()}${!_keyValid ? '*' : ''}'
                    : '${LocaleKeys.header_key_title.tr()}${!_keyValid ? '*' : ''}',
                labelStyle: TextStyle(
                  color: _keyValid
                      ? Theme.of(context).inputDecorationTheme.labelStyle!.color
                      : Theme.of(context).colorScheme.error,
                ),
                floatingLabelStyle: TextStyle(
                  color: !_keyValid
                      ? Theme.of(context).colorScheme.error
                      : _keyFocus.hasFocus
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).inputDecorationTheme.enabledBorder!.borderSide.color,
                ),
              ),
              onTap: () {
                setState(() {
                  _keyFocus.requestFocus();
                });
              },
              validator: (value) {
                if (isBlank(value)) {
                  setState(() {
                    _keyValid = false;
                  });
                  return LocaleKeys.cannot_be_blank_message.tr();
                }
                setState(() {
                  _keyValid = true;
                });
                return null;
              },
            ),
            const Gap(16),
            TextFormField(
              controller: _valueController,
              focusNode: _valueFocus,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: widget.headerType == CustomHeaderType.basicAuth
                    ? '${LocaleKeys.password_title.tr()}${!_valueValid ? '*' : ''}'
                    : '${LocaleKeys.header_value_title.tr()}${!_valueValid ? '*' : ''}',
                labelStyle: TextStyle(
                  color: _valueValid
                      ? Theme.of(context).inputDecorationTheme.labelStyle!.color
                      : Theme.of(context).colorScheme.error,
                ),
                floatingLabelStyle: TextStyle(
                  color: !_valueValid
                      ? Theme.of(context).colorScheme.error
                      : _valueFocus.hasFocus
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).inputDecorationTheme.enabledBorder!.borderSide.color,
                ),
              ),
              onTap: () {
                setState(() {
                  _valueFocus.requestFocus();
                });
              },
              validator: (value) {
                if (isBlank(value)) {
                  setState(() {
                    _valueValid = false;
                  });
                  return LocaleKeys.cannot_be_blank_message.tr();
                }
                setState(() {
                  _valueValid = true;
                });
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text(LocaleKeys.cancel_title).tr(),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text(LocaleKeys.save_title).tr(),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              if (widget.forRegistration) {
                context.read<RegistrationHeadersBloc>().add(
                      RegistrationHeadersUpdate(
                        title: _keyController.value.text.trim(),
                        subtitle: _valueController.value.text.trim(),
                        basicAuth: widget.headerType == CustomHeaderType.basicAuth,
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
                          basicAuth: widget.headerType == CustomHeaderType.basicAuth,
                          previousTitle: widget.existingKey,
                        ),
                      );
                }
              }

              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
