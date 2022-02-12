import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../bloc/registration_headers_bloc.dart';
import '../../bloc/settings_bloc.dart';
import '../dialogs/custom_header_config_dialog.dart';
import '../dialogs/delete_dialog.dart';

class CustomHeaderListTile extends StatelessWidget {
  final bool forRegistration;
  final String title;
  final String subtitle;
  final bool showLeading;
  final String? tautulliId;
  final bool sensitive;

  const CustomHeaderListTile({
    Key? key,
    required this.forRegistration,
    required this.title,
    required this.subtitle,
    this.showLeading = true,
    this.tautulliId,
    this.sensitive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Material(
          child: ListTile(
            leading: showLeading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        width: 35,
                        child: FaIcon(FontAwesomeIcons.solidAddressCard),
                      ),
                    ],
                  )
                : null,
            title: Text(title),
            subtitle: Text(
              sensitive &&
                      state is SettingsSuccess &&
                      state.appSettings.maskSensitiveInfo
                  ? 'HIDDEN'
                  : subtitle,
              style: Theme.of(context).textTheme.subtitle2,
            ),
            trailing: GestureDetector(
              child: const FaIcon(
                FontAwesomeIcons.solidTimesCircle,
              ),
              onTap: () async {
                final result = await showDialog(
                  context: context,
                  builder: (_) => DeleteDialog(
                    title: Text(
                      "Are you sure you want to remove the header '$title'?",
                    ),
                  ),
                );

                if (result) {
                  if (forRegistration) {
                    context.read<RegistrationHeadersBloc>().add(
                          RegistrationHeadersDelete(title),
                        );
                  } else {
                    if (tautulliId != null) {
                      context.read<SettingsBloc>().add(
                            SettingsDeleteCustomHeader(
                              tautulliId: tautulliId!,
                              title: title,
                            ),
                          );
                    }
                  }
                }
              },
            ),
            onTap: () async {
              final bool isBasicAuth =
                  title == 'Authorization' && subtitle.startsWith('Basic ');

              if (isBasicAuth) {
                try {
                  final List<String> creds = utf8
                      .decode(base64Decode(subtitle.substring(6)))
                      .split(':');

                  await showDialog(
                    context: context,
                    builder: (_) {
                      return CustomHeaderConfigDialog(
                        tautulliId: tautulliId,
                        headerType: CustomHeaderType.basicAuth,
                        forRegistration: forRegistration,
                        existingKey: creds[0],
                        existingValue: creds[1],
                      );
                    },
                  );
                } catch (_) {
                  await showDialog(
                    context: context,
                    builder: (_) {
                      return CustomHeaderConfigDialog(
                        tautulliId: tautulliId,
                        headerType: CustomHeaderType.basicAuth,
                        forRegistration: forRegistration,
                        existingKey: title,
                        existingValue: subtitle,
                        // currentHeaders: server.customHeaders,
                      );
                    },
                  );
                }
              } else {
                await showDialog(
                  context: context,
                  builder: (_) {
                    return CustomHeaderConfigDialog(
                      tautulliId: tautulliId,
                      headerType: CustomHeaderType.custom,
                      forRegistration: forRegistration,
                      existingKey: title,
                      existingValue: subtitle,
                      // currentHeaders: server.customHeaders,
                    );
                  },
                );
              }
            },
          ),
        );
      },
    );
  }
}
