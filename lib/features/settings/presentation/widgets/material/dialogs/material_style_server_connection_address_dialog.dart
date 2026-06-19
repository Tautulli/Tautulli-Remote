import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/strings.dart';
import 'package:validators/validators.dart';

import '../../../../../../core/database/data/models/server_model.dart';
import '../../../../../../core/widgets/material/material_style_text_form_field.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class MaterialStyleServerConnectionAddressDialog extends StatefulWidget {
  final bool primary;
  final ServerModel server;

  const MaterialStyleServerConnectionAddressDialog({
    super.key,
    required this.primary,
    required this.server,
  });

  @override
  State<MaterialStyleServerConnectionAddressDialog> createState() =>
      _MaterialStyleServerConnectionAddressDialogState();
}

class _MaterialStyleServerConnectionAddressDialogState
    extends State<MaterialStyleServerConnectionAddressDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    if (widget.primary) {
      _controller.text = widget.server.primaryConnectionAddress;
    }
    if (!widget.primary && widget.server.secondaryConnectionAddress != null) {
      _controller.text = widget.server.secondaryConnectionAddress!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.primary ? LocaleKeys.primary_connection_title : LocaleKeys.secondary_connection_title,
      ).tr(),
      content: Form(
        key: _formKey,
        child: MaterialStyleTextFormField(
          controller: _controller,
          hintText: widget.primary
              ? LocaleKeys.primary_connection_address_hint.tr()
              : LocaleKeys.secondary_connection_address_hint.tr(),
          errorMaxLines: 2,
          validator: (value) {
            bool validUrl = isURL(
              value,
              protocols: ['http', 'https'],
              requireProtocol: true,
              allowUnderscore: true,
            );
            if ((widget.primary && validUrl == false) ||
                (!widget.primary && isNotBlank(_controller.text) && validUrl == false)) {
              return widget.primary
                  ? LocaleKeys.server_connection_address_dialog_primary_validation.tr()
                  : LocaleKeys.server_connection_address_dialog_secondary_validation.tr();
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          child: const Text(LocaleKeys.close_title).tr(),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          child: const Text(LocaleKeys.save_title).tr(),
          onPressed: () {
            if (_formKey.currentState != null && _formKey.currentState!.validate()) {
              context.read<SettingsBloc>().add(
                SettingsUpdateConnectionInfo(
                  primary: widget.primary,
                  connectionAddress: _controller.text,
                  server: widget.server,
                ),
              );
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
