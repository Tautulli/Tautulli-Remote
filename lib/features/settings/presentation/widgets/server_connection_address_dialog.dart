import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/strings.dart';
import 'package:validators/validators.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../bloc/settings_bloc.dart';

class ServerConnectionAddressDialog extends StatelessWidget {
  final bool primary;
  final ServerModel server;

  const ServerConnectionAddressDialog({
    Key? key,
    required this.primary,
    required this.server,
  }) : super(key: key);

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
        '${primary ? 'Primary' : 'Secondary'} Connection',
      ),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: controller,
          autocorrect: false,
          decoration: InputDecoration(
            hintText:
                'Input your ${primary ? 'primary' : 'secondary'} connection address',
            errorMaxLines: 2,
          ),
          validator: (value) {
            bool validUrl = isURL(
              value,
              protocols: ['http', 'https'],
              requireProtocol: true,
            );
            if ((primary && validUrl == false) ||
                (!primary &&
                    isNotBlank(controller.text) &&
                    validUrl == false)) {
              return 'Please enter a valid URL format${!primary ? ' or remove all text to disable' : ''}';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          child: const Text('CLOSE'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('SAVE'),
          onPressed: () {
            if (formKey.currentState != null &&
                formKey.currentState!.validate()) {
              if (isEmpty(controller.text) && server.primaryActive != true) {
                //TODO
                // context.read<SettingsBloc>().add(
                //       SettingsUpdatePrimaryActive(
                //         primaryActive: true,
                //         server: server,
                //       ),
                //     );
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
