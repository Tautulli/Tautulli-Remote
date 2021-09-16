// @dart=2.9

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../translations/locale_keys.g.dart';
import '../bloc/register_device_headers_bloc.dart';
import '../bloc/settings_bloc.dart';

class HeaderConfigDialog extends StatefulWidget {
  final String tautulliId;
  final bool basicAuth;
  final bool registerDevice;

  const HeaderConfigDialog({
    Key key,
    this.tautulliId,
    this.basicAuth = false,
    this.registerDevice = false,
  }) : super(key: key);

  @override
  _HeaderConfigDialogState createState() => _HeaderConfigDialogState();
}

class _HeaderConfigDialogState extends State<HeaderConfigDialog> {
  @override
  Widget build(BuildContext context) {
    final _keyController = TextEditingController();
    final _valueController = TextEditingController();

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
      content: Column(
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
          ),
          TextFormField(
            controller: _valueController,
            obscureText: widget.basicAuth,
            decoration: InputDecoration(
              labelText: widget.basicAuth
                  ? LocaleKeys.settings_header_input_password.tr()
                  : LocaleKeys.settings_header_input_header_value.tr(),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(LocaleKeys.button_close).tr(),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text(LocaleKeys.button_save).tr(),
          onPressed: () {
            if (!widget.registerDevice) {
              context.read<SettingsBloc>().add(
                    SettingsAddCustomHeader(
                      tautulliId: widget.tautulliId,
                      key: _keyController.value.text,
                      value: _valueController.value.text,
                      basicAuth: widget.basicAuth,
                    ),
                  );
            } else {
              context.read<RegisterDeviceHeadersBloc>().add(
                    RegisterDeviceHeadersAdd(
                      key: _keyController.value.text,
                      value: _valueController.value.text,
                      basicAuth: widget.basicAuth,
                    ),
                  );
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
