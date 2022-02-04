import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../bloc/registration_headers_bloc.dart';
import 'custom_header_config_dialog.dart';

class CustomHeaderTypeDialog extends StatelessWidget {
  const CustomHeaderTypeDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.solidAddressCard),
          title: const Text('Basic Authentication'),
          onTap: () async {
            Navigator.of(context).pop();

            await showDialog(
              context: context,
              builder: (_) {
                return BlocProvider.value(
                  value: context.read<RegistrationHeadersBloc>(),
                  child: const CustomHeaderConfigDialog(
                    headerType: CustomHeaderType.basicAuth,
                  ),
                );
              },
            );
          },
        ),
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.addressCard),
          title: const Text('Custom'),
          onTap: () async {
            Navigator.of(context).pop();

            await showDialog(
              context: context,
              builder: (_) {
                return BlocProvider.value(
                  value: context.read<RegistrationHeadersBloc>(),
                  child: const CustomHeaderConfigDialog(
                    headerType: CustomHeaderType.custom,
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
