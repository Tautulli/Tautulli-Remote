import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiver/strings.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../injection_container.dart' as di;
import '../../../settings/presentation/bloc/register_device_bloc.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../settings/presentation/pages/server_registration_page.dart';
import '../../../settings/presentation/pages/server_settings_page.dart';
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
                top: 20,
                left: 16,
                right: 16,
                bottom: 12,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Welcome to Tautulli Remote. This app connects to one or more of your existing Tautulli instances to view activity, history, stats, and more.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'In order to set up Tautulli Remote please make sure Tautulli is currently running and you can access it from this device.',
                    style: TextStyle(fontSize: 16),
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
                                        const Padding(
                                          padding: EdgeInsets.only(
                                            top: 8,
                                            left: 16,
                                            right: 16,
                                          ),
                                          child: ServerSetupInstructions(
                                            showWarning: false,
                                            fontSize: 16,
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
                                                    'Primary Connection Address Missing')
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
                                                            '*Hidden Connection Address*'),
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
                                              fullscreenDialog: true,
                                              builder: (context) {
                                                return BlocProvider(
                                                  create: (context) => di
                                                      .sl<RegisterDeviceBloc>(),
                                                  child: ServerRegistrationPage(
                                                    fontSize: 16,
                                                  ),
                                                );
                                              },
                                            ),
                                          );

                                          if (result == true) {
                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                backgroundColor: Colors.green,
                                                content: Text(
                                                    'Tautulli Registration Successful'),
                                              ),
                                            );
                                          }
                                        },
                                        child: const Text(
                                            'Register a Tautulli Server'),
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
