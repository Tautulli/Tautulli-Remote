// @dart=2.9

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiver/strings.dart';

import '../../../../core/database/data/models/custom_header_model.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../translations/locale_keys.g.dart';
import '../bloc/register_device_headers_bloc.dart';
import '../bloc/settings_bloc.dart';

class HeaderConfigDialog extends StatefulWidget {
  final String tautulliId;
  final bool basicAuth;
  final bool registerDevice;
  final String existingKey;
  final String existingValue;
  final List<CustomHeaderModel> currentHeaders;

  const HeaderConfigDialog({
    Key key,
    this.tautulliId,
    this.basicAuth = false,
    this.registerDevice = false,
    this.existingKey,
    this.existingValue,
    this.currentHeaders = const [],
  }) : super(key: key);

  @override
  _HeaderConfigDialogState createState() => _HeaderConfigDialogState();
}

class _HeaderConfigDialogState extends State<HeaderConfigDialog> {
  List<CustomHeaderModel> headerValidationList = [];

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _keyController = TextEditingController();
    final _valueController = TextEditingController();

    if (widget.existingKey != null && widget.existingValue != null) {
      _keyController.text = widget.existingKey;
      _valueController.text = widget.existingValue;
    }

    if (widget.currentHeaders.isNotEmpty) {
      headerValidationList = [...widget.currentHeaders];
      headerValidationList.removeWhere(
        (header) => header.key == widget.existingKey,
      );
    }

    return AlertDialog(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            widget.basicAuth
                ? FontAwesomeIcons.solidAddressCard
                : FontAwesomeIcons.addressCard,
            color: TautulliColorPalette.not_white,
          ),
          const SizedBox(width: 8),
          Text(
            widget.basicAuth
                ? LocaleKeys.settings_header_basic_auth.tr()
                : LocaleKeys.general_filter_custom.tr(),
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
              autofocus: true,
              decoration: InputDecoration(
                labelText: widget.basicAuth
                    ? LocaleKeys.settings_header_input_username.tr()
                    : LocaleKeys.settings_header_input_header_key.tr(),
              ),
              validator: (value) {
                if (isBlank(value)) {
                  return LocaleKeys.settings_validation_blank.tr();
                }
                final keyExists = headerValidationList.firstWhere(
                  (header) =>
                      header.key.toLowerCase() == value.trim().toLowerCase(),
                  orElse: () => null,
                );
                print(keyExists);
                if (keyExists != null) {
                  return LocaleKeys.settings_validation_header_key_exists.tr();
                }
                return null;
              },
            ),
            TextFormField(
              controller: _valueController,
              obscureText: widget.basicAuth,
              decoration: InputDecoration(
                labelText: widget.basicAuth
                    ? LocaleKeys.settings_header_input_password.tr()
                    : LocaleKeys.settings_header_input_header_value.tr(),
              ),
              validator: (value) {
                if (isBlank(value)) {
                  return LocaleKeys.settings_validation_blank.tr();
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            widget.existingKey != null
                ? LocaleKeys.button_close
                : LocaleKeys.button_cancel,
          ).tr(),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text(LocaleKeys.button_save).tr(),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              if (!widget.registerDevice) {
                context.read<SettingsBloc>().add(
                      SettingsAddCustomHeader(
                        tautulliId: widget.tautulliId,
                        key: _keyController.value.text.trim(),
                        value: _valueController.value.text.trim(),
                        basicAuth: widget.basicAuth,
                        previousKey: widget.existingKey,
                      ),
                    );
              } else {
                context.read<RegisterDeviceHeadersBloc>().add(
                      RegisterDeviceHeadersAdd(
                        key: _keyController.value.text.trim(),
                        value: _valueController.value.text.trim(),
                        basicAuth: widget.basicAuth,
                        previousKey: widget.existingKey,
                      ),
                    );
              }
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
