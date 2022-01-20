import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
              builder: (context) => const CustomHeaderConfigDialog(
                headerType: CustomHeaderType.basicAuth,
              ),
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
              builder: (context) => const CustomHeaderConfigDialog(
                headerType: CustomHeaderType.custom,
              ),
            );
          },
        ),
      ],
    );
  }
}
