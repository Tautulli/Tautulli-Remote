// @dart=2.9

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/database/data/models/custom_header_model.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../translations/locale_keys.g.dart';
import 'header_config_dialog.dart';

class HeaderTypeDialog extends StatelessWidget {
  final String tautulliId;
  final bool registerDevice;
  final List<CustomHeaderModel> currentHeaders;

  const HeaderTypeDialog({
    Key key,
    this.tautulliId,
    this.registerDevice = false,
    this.currentHeaders = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authorizationKeyExists = currentHeaders.firstWhere(
      (header) => header.key.toLowerCase() == 'authorization',
      orElse: () => null,
    );

    return SimpleDialog(
      children: [
        ListTile(
          enabled: authorizationKeyExists == null,
          leading: FaIcon(
            FontAwesomeIcons.solidAddressCard,
            color: authorizationKeyExists == null
                ? TautulliColorPalette.not_white
                : Colors.grey,
          ),
          title: const Text(
            LocaleKeys.settings_header_basic_auth,
          ).tr(),
          subtitle: authorizationKeyExists != null
              ? const Text(LocaleKeys.settings_header_basic_auth_disabled).tr()
              : null,
          onTap: () {
            Navigator.of(context).pop();
            return showDialog(
              context: context,
              builder: (context) {
                return HeaderConfigDialog(
                  tautulliId: tautulliId,
                  basicAuth: true,
                  registerDevice: registerDevice,
                  currentHeaders: currentHeaders,
                );
              },
            );
          },
        ),
        ListTile(
          leading: const FaIcon(
            FontAwesomeIcons.addressCard,
            color: TautulliColorPalette.not_white,
          ),
          title: const Text(LocaleKeys.general_filter_custom).tr(),
          onTap: () {
            Navigator.of(context).pop();
            return showDialog(
              context: context,
              builder: (context) {
                return HeaderConfigDialog(
                  tautulliId: tautulliId,
                  registerDevice: registerDevice,
                  currentHeaders: currentHeaders,
                );
              },
            );
          },
        ),
      ],
    );
  }
}
