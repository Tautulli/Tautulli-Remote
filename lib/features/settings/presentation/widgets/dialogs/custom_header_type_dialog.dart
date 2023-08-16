import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../translations/locale_keys.g.dart';
import '../../../data/models/custom_header_model.dart';
import 'custom_header_config_dialog.dart';

class CustomHeaderTypeDialog extends StatelessWidget {
  final bool forRegistration;
  final String? tautulliId;
  final List<CustomHeaderModel>? currentHeaders;

  const CustomHeaderTypeDialog({
    super.key,
    required this.forRegistration,
    this.tautulliId,
    this.currentHeaders,
  });

  @override
  Widget build(BuildContext context) {
    final bool authHeaderExists = currentHeaders?.indexWhere((header) => header.key == 'Authorization') != -1;

    return SimpleDialog(
      clipBehavior: Clip.hardEdge,
      children: [
        ListTile(
          enabled: !authHeaderExists,
          leading: SizedBox(
            width: 35,
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.solidAddressCard,
                color: !authHeaderExists ? Theme.of(context).colorScheme.onSurface : Theme.of(context).disabledColor,
              ),
            ),
          ),
          title: const Text(LocaleKeys.basic_authentication_title).tr(),
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
          leading: SizedBox(
            width: 35,
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.addressCard,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          title: const Text(LocaleKeys.custom_title).tr(),
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
