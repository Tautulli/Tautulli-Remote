import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../translations/locale_keys.g.dart';
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
    super.key,
    required this.forRegistration,
    required this.title,
    required this.subtitle,
    this.showLeading = true,
    this.tautulliId,
    this.sensitive = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Material(
          color: ElevationOverlay.applySurfaceTint(
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surfaceTint,
            1,
          ),
          child: ListTile(
            leading: showLeading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 35,
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.solidAddressCard,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  )
                : null,
            title: Text(title),
            subtitle: Text(
              sensitive && state is SettingsSuccess && state.appSettings.maskSensitiveInfo ? LocaleKeys.hidden_message : subtitle,
              style: Theme.of(context).textTheme.titleSmall,
            ).tr(),
            trailing: GestureDetector(
              child: SizedBox(
                width: 35,
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.solidCircleXmark,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              onTap: () async {
                final result = await showDialog(
                  context: context,
                  builder: (_) => DeleteDialog(
                    title: const Text(
                      LocaleKeys.server_delete_dialog_title,
                    ).tr(args: [title]),
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
              final bool isBasicAuth = title == 'Authorization' && subtitle.startsWith('Basic ');

              if (isBasicAuth) {
                try {
                  final List<String> creds = utf8.decode(base64Decode(subtitle.substring(6))).split(':');

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
