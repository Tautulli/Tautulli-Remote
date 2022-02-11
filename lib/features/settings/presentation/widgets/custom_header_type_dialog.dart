import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/models/custom_header_model.dart';
import 'custom_header_config_dialog.dart';

class CustomHeaderTypeDialog extends StatelessWidget {
  final bool forRegistration;
  final String? tautulliId;
  final List<CustomHeaderModel>? currentHeaders;

  const CustomHeaderTypeDialog({
    Key? key,
    required this.forRegistration,
    this.tautulliId,
    this.currentHeaders,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool authHeaderExists =
        currentHeaders?.indexWhere((header) => header.key == 'Authorization') !=
            -1;

    return SimpleDialog(
      children: [
        ListTile(
          enabled: !authHeaderExists,
          leading: const FaIcon(FontAwesomeIcons.solidAddressCard),
          title: const Text('Basic Authentication'),
          onTap: () async {
            Navigator.of(context).pop();

            await showDialog(
              context: context,
              builder: (_) {
                return CustomHeaderConfigDialog(
                  headerType: CustomHeaderType.basicAuth,
                  forRegistration: forRegistration,
                  tautulliId: tautulliId,
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
                return CustomHeaderConfigDialog(
                  headerType: CustomHeaderType.custom,
                  forRegistration: forRegistration,
                  tautulliId: tautulliId,
                );
              },
            );
          },
        ),
      ],
    );
  }
}
