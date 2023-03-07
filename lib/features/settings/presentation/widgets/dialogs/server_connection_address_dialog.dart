import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/strings.dart';
import 'package:validators/validators.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/settings_bloc.dart';

class ServerConnectionAddressDialog extends StatelessWidget {
  final bool primary;
  final ServerModel server;

  const ServerConnectionAddressDialog({
    super.key,
    required this.primary,
    required this.server,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController();

    if (primary) {
      controller.text = server.primaryConnectionAddress;
    }
    if (!primary && server.secondaryConnectionAddress != null) {
      controller.text = server.secondaryConnectionAddress!;
    }

    return AlertDialog(
      title: Text(
        primary ? LocaleKeys.primary_connection_title : LocaleKeys.secondary_connection_title,
      ).tr(),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: controller,
          autocorrect: false,
          decoration: InputDecoration(
            hintText: primary
                ? LocaleKeys.primary_connection_address_hint.tr()
                : LocaleKeys.secondary_connection_address_hint.tr(),
            errorMaxLines: 2,
          ),
          validator: (value) {
            bool validUrl = isURL(
              value,
              protocols: ['http', 'https'],
              requireProtocol: true,
            );
            if ((primary && validUrl == false) || (!primary && isNotBlank(controller.text) && validUrl == false)) {
              return primary
                  ? LocaleKeys.server_connection_address_dialog_primary_validation.tr()
                  : LocaleKeys.server_connection_address_dialog_secondary_validation.tr();
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          child: const Text(LocaleKeys.close_title).tr(),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text(LocaleKeys.save_title).tr(),
          onPressed: () {
            if (formKey.currentState != null && formKey.currentState!.validate()) {
              if (isEmpty(controller.text) && server.primaryActive != true) {
                context.read<SettingsBloc>().add(
                      SettingsUpdatePrimaryActive(
                        tautulliId: server.tautulliId,
                        primaryActive: true,
                      ),
                    );
              }

              context.read<SettingsBloc>().add(
                    SettingsUpdateConnectionInfo(
                      primary: primary,
                      connectionAddress: controller.text,
                      server: server,
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
