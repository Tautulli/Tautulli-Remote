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
    return Padding(
      padding: const EdgeInsets.only(top: 42),
      child: Column(
        children: [
          const Text(
            'Register Tautulli Servers',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 17,
                  bottom: 8,
                  left: 16.0,
                  right: 16.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Tautulli Remote allows you to register with multiple Tautulli servers.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    ServerSetupInstructions(
                      showWarning: false,
                    ),
                  ],
                ),
              ),
              const Divider(
                indent: 8,
                endIndent: 8,
              ),
              BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  if (state is SettingsLoadSuccess) {
                    return Column(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: state.serverList
                              .map(
                                (server) => ListTile(
                                  key: ValueKey(server.id),
                                  title: Text('${server.plexName}'),
                                  subtitle: (isEmpty(
                                          server.primaryConnectionAddress))
                                      ? const Text(
                                          'Primary Connection Address Missing')
                                      : isNotEmpty(server
                                                  .primaryConnectionAddress) &&
                                              server.primaryActive &&
                                              !state.maskSensitiveInfo
                                          ? Text(
                                              server.primaryConnectionAddress)
                                          : isNotEmpty(server
                                                      .primaryConnectionAddress) &&
                                                  !server.primaryActive &&
                                                  !state.maskSensitiveInfo
                                              ? Text(server
                                                  .secondaryConnectionAddress)
                                              : const Text(
                                                  '*Hidden Connection Address*'),
                                  trailing: const FaIcon(
                                    FontAwesomeIcons.cog,
                                    color: TautulliColorPalette.not_white,
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ServerSettingsPage(
                                            id: server.id,
                                            plexName: server.plexName,
                                            maskSensitiveInfo:
                                                state.maskSensitiveInfo,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              )
                              .toList(),
                        ),
                        //TODO: may not need if we move to nesting all registering in a single page
                        BlocBuilder<RegisterDeviceBloc, RegisterDeviceState>(
                          builder: (context, state) {
                            if (state is RegisterDeviceInProgress) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 6, bottom: 8),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            return const SizedBox(height: 0, width: 0);
                          },
                        ),
                        ListTile(
                          title: const Text(
                            'Register with a Tautulli Server',
                          ),
                          trailing: const FaIcon(
                            FontAwesomeIcons.plusCircle,
                            color: TautulliColorPalette.not_white,
                          ),
                          onTap: () async {
                            bool result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context) {
                                  return BlocProvider(
                                    create: (context) =>
                                        di.sl<RegisterDeviceBloc>(),
                                    child: ServerRegistrationPage(),
                                  );
                                },
                              ),
                            );

                            // If manual registration page pops with true show success snackbar
                            if (result == true) {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.green,
                                  content:
                                      Text('Tautulli Registration Successful'),
                                ),
                              );
                            }
                          },
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
    );
  }
}
