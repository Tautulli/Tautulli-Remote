import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiver/strings.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../injection_container.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/bloc/register_device_bloc.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../settings/presentation/pages/server_registration_page.dart';
import '../../../settings/presentation/pages/server_settings_page.dart';
import '../../../settings/presentation/widgets/language_dialog.dart';
import '../../../settings/presentation/widgets/server_setup_instructions.dart';

class Servers extends StatelessWidget {
  const Servers({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<RegisterDeviceBloc>(),
      child: const ServersContent(),
    );
  }
}

class ServersContent extends StatelessWidget {
  const ServersContent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 42),
        child: Column(
          children: [
            Container(
              height: 75,
              decoration:
                  const BoxDecoration(color: TautulliColorPalette.midnight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 75,
                        padding: const EdgeInsets.only(right: 3),
                        child: Image.asset('assets/logo/logo_transparent.png'),
                      ),
                      SizedBox(
                        height: 75,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Tautulli',
                                  style: TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Remote',
                                  style: TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 30,
                left: 16,
                right: 16,
                // bottom: 12,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    LocaleKeys.wizard_servers_text_1,
                    style: TextStyle(fontSize: 18),
                  ).tr(),
                  const SizedBox(height: 12),
                  const Text(
                    LocaleKeys.wizard_servers_text_2,
                    style: TextStyle(fontSize: 16),
                  ).tr(),
                  const SizedBox(height: 12),
                  const Text(
                    LocaleKeys.wizard_servers_text_3,
                    style: TextStyle(fontSize: 16),
                  ).tr(),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            return showDialog(
                              context: context,
                              builder: (context) => LanguageDialog(
                                initialValue: context.locale,
                              ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.language,
                                color: TautulliColorPalette.not_white,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                LocaleKeys.translate_change_language,
                              ).tr(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              indent: 8,
              endIndent: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<SettingsBloc, SettingsState>(
                  builder: (context, state) {
                    if (state is SettingsLoadSuccess) {
                      return Column(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: state.serverList.isEmpty
                                    ? [
                                        // ignore: prefer_const_constructors
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                            left: 16,
                                            right: 16,
                                          ),
                                          // ignore: prefer_const_constructors
                                          child: ServerSetupInstructions(
                                            showWarning: false,
                                          ),
                                        ),
                                      ]
                                    : state.serverList
                                        .map(
                                          (server) => ListTile(
                                            key: ValueKey(server.id),
                                            title: Text('${server.plexName}'),
                                            subtitle: (isEmpty(server
                                                    .primaryConnectionAddress))
                                                ? const Text(
                                                    LocaleKeys
                                                        .settings_primary_connection_missing,
                                                  ).tr()
                                                : isNotEmpty(server
                                                            .primaryConnectionAddress) &&
                                                        server.primaryActive &&
                                                        !state.maskSensitiveInfo
                                                    ? Text(server
                                                        .primaryConnectionAddress)
                                                    : isNotEmpty(server
                                                                .primaryConnectionAddress) &&
                                                            !server
                                                                .primaryActive &&
                                                            !state
                                                                .maskSensitiveInfo
                                                        ? Text(server
                                                            .secondaryConnectionAddress)
                                                        : const Text(
                                                            '*${LocaleKeys.masked_info_connection_address}*',
                                                          ),
                                            trailing: const FaIcon(
                                              FontAwesomeIcons.cog,
                                              color: TautulliColorPalette
                                                  .not_white,
                                            ),
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return ServerSettingsPage(
                                                      id: server.id,
                                                      plexName: server.plexName,
                                                      maskSensitiveInfo: state
                                                          .maskSensitiveInfo,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                        .toList(),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  left: 16,
                                  right: 16,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary:
                                              Theme.of(context).accentColor,
                                        ),
                                        onPressed: () async {
                                          bool result =
                                              await Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return BlocProvider(
                                                  create: (context) => di
                                                      .sl<RegisterDeviceBloc>(),
                                                  child:
                                                      ServerRegistrationPage(),
                                                );
                                              },
                                            ),
                                          );

                                          if (result == true) {
                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor: Colors.green,
                                                content: const Text(
                                                  LocaleKeys
                                                      .settings_registration_success,
                                                ).tr(),
                                              ),
                                            );
                                          }
                                        },
                                        child: const Text(
                                          LocaleKeys.button_register_server,
                                        ).tr(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                    return const SizedBox(height: 0, width: 0);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
