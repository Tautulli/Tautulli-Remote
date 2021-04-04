import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiver/strings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:validators/validators.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../bloc/settings_bloc.dart';

class ServerSettingsPage extends StatelessWidget {
  final int id;
  final String plexName;
  final bool maskSensitiveInfo;

  const ServerSettingsPage({
    Key key,
    @required this.id,
    @required this.plexName,
    @required this.maskSensitiveInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsBloc = context.read<SettingsBloc>();
    final _primaryConnectionAddressController = TextEditingController();
    final _secondaryConnectionAddressController = TextEditingController();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('$plexName Settings'),
        actions: <Widget>[
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.trashAlt,
              color: TautulliColorPalette.not_white,
            ),
            onPressed: () async {
              bool delete = await _showDeleteServerDialog(
                context: context,
                plexName: plexName,
              );
              if (delete) {
                settingsBloc.add(
                  SettingsDeleteServer(
                    id: id,
                    plexName: plexName,
                  ),
                );
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoadSuccess) {
            try {
              final ServerModel server =
                  state.serverList.firstWhere((item) => item.id == id);
              return ListView(
                children: <Widget>[
                  ListTile(
                    title: const Text('Primary Connection Address'),
                    subtitle: isEmpty(server.primaryConnectionAddress)
                        ? const Text('Required')
                        : isNotEmpty(server.primaryConnectionAddress) &&
                                !maskSensitiveInfo
                            ? Text(server.primaryConnectionAddress)
                            : const Text('*Hidden Connection Address*'),
                    trailing: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.5,
                          color: server.primaryActive
                              ? Theme.of(context).accentColor
                              : Colors.grey[700],
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                      ),
                      child: Text(
                        isNotEmpty(server.primaryConnectionAddress) &&
                                server.primaryActive
                            ? 'Active'
                            : isNotEmpty(server.primaryConnectionAddress)
                                ? 'Passive'
                                : 'Disabled',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: server.primaryActive
                              ? Theme.of(context).accentColor
                              : Colors.grey[700],
                        ),
                      ),
                    ),
                    onTap: () {
                      _buildPrimaryConnectionAddressSettingsDialog(
                        context: context,
                        id: server.id,
                        plexName: plexName,
                        primaryConnectionAddress:
                            server.primaryConnectionAddress,
                        controller: _primaryConnectionAddressController,
                        settingsBloc: settingsBloc,
                      );
                    },
                    onLongPress: () {
                      if (isNotEmpty(server.primaryConnectionAddress)) {
                        Clipboard.setData(
                          ClipboardData(text: server.primaryConnectionAddress),
                        );
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: PlexColorPalette.shark,
                            content: Text('Copied to clipboard'),
                          ),
                        );
                      }
                    },
                  ),
                  ListTile(
                    title: const Text('Secondary Connection Address'),
                    subtitle: isEmpty(server.secondaryConnectionAddress)
                        ? const Text('Not configured')
                        : isNotEmpty(server.secondaryConnectionAddress) &&
                                !maskSensitiveInfo
                            ? Text(server.secondaryConnectionAddress)
                            : const Text('*Hidden Connection Address*'),
                    trailing: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.5,
                          color: !server.primaryActive
                              ? Theme.of(context).accentColor
                              : Colors.grey[700],
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                      ),
                      child: Text(
                        isEmpty(server.secondaryConnectionAddress)
                            ? 'Disabled'
                            : !server.primaryActive
                                ? 'Active'
                                : 'Passive',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: !server.primaryActive
                              ? Theme.of(context).accentColor
                              : Colors.grey[700],
                        ),
                      ),
                    ),
                    onTap: () {
                      _buildSecondaryConnectionAddressSettingsDialog(
                        context: context,
                        id: server.id,
                        plexName: plexName,
                        secondaryConnectionAddress:
                            server.secondaryConnectionAddress,
                        controller: _secondaryConnectionAddressController,
                        settingsBloc: settingsBloc,
                      );
                    },
                    onLongPress: () {
                      if (isNotEmpty(server.secondaryConnectionAddress)) {
                        Clipboard.setData(
                          ClipboardData(
                              text: server.secondaryConnectionAddress),
                        );
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: PlexColorPalette.shark,
                            content: Text('Copied to clipboard'),
                          ),
                        );
                      }
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Device Token',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    subtitle: Text(
                      maskSensitiveInfo
                          ? '*Hidden Device Token*'
                          : server.deviceToken,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: PlexColorPalette.shark,
                          content: const Text('Device tokens cannot be edited'),
                          action: SnackBarAction(
                            label: 'LEARN MORE',
                            onPressed: () async {
                              await launch(
                                'https://github.com/Tautulli/Tautulli-Remote/wiki/Settings#device_tokens',
                              );
                            },
                            textColor: TautulliColorPalette.not_white,
                          ),
                        ),
                      );
                    },
                    onLongPress: () {
                      if (isNotEmpty(server.deviceToken)) {
                        Clipboard.setData(
                          ClipboardData(text: server.deviceToken),
                        );
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: PlexColorPalette.shark,
                            content: Text('Copied to clipboard'),
                          ),
                        );
                      }
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                  ListTile(
                    title: Text('Open ${server.plexName} in browser'),
                    trailing: const FaIcon(
                      FontAwesomeIcons.externalLinkAlt,
                      color: TautulliColorPalette.not_white,
                      size: 20,
                    ),
                    onTap: () async {
                      if (server.primaryActive) {
                        await launch(server.primaryConnectionAddress);
                      } else {
                        await launch(server.secondaryConnectionAddress);
                      }
                    },
                  ),
                ],
              );
            } catch (error) {
              return Text('Server not found in settings [$error]');
            }
          }
          return const Text('Bloc error');
        },
      ),
    );
  }
}

Future _buildPrimaryConnectionAddressSettingsDialog({
  @required BuildContext context,
  @required int id,
  @required String plexName,
  @required String primaryConnectionAddress,
  @required TextEditingController controller,
  @required SettingsBloc settingsBloc,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      final _primaryConnectionFormKey = GlobalKey<FormState>();

      if (primaryConnectionAddress != null) {
        controller.text = primaryConnectionAddress;
      }
      return AlertDialog(
        title: const Text('Tautulli Primary Connection Address'),
        content: Form(
          key: _primaryConnectionFormKey,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
                hintText: 'Input your primary connection address'),
            validator: (value) {
              bool validUrl = isURL(
                value,
                protocols: ['http', 'https'],
                requireProtocol: true,
              );
              if (validUrl == false) {
                return 'Please enter a valid URL format';
              }
              return null;
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("CLOSE"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("SAVE"),
            onPressed: () {
              if (_primaryConnectionFormKey.currentState.validate()) {
                settingsBloc.add(
                  SettingsUpdatePrimaryConnection(
                    id: id,
                    primaryConnectionAddress: controller.text,
                    plexName: plexName,
                  ),
                );
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}

Future _buildSecondaryConnectionAddressSettingsDialog({
  @required BuildContext context,
  @required int id,
  @required String plexName,
  @required String secondaryConnectionAddress,
  @required TextEditingController controller,
  @required SettingsBloc settingsBloc,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      final _secondaryConnectionFormKey = GlobalKey<FormState>();

      if (secondaryConnectionAddress != null) {
        controller.text = secondaryConnectionAddress;
      }
      return AlertDialog(
        title: const Text('Tautulli Secondary Connection Address'),
        content: Form(
          key: _secondaryConnectionFormKey,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
                hintText: 'Input your secondary connection address'),
            validator: (value) {
              bool validUrl = isURL(
                value,
                protocols: ['http', 'https'],
                requireProtocol: true,
              );
              if (isNotEmpty(controller.text) && validUrl == false) {
                return 'Please enter a valid URL format';
              }
              return null;
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("CLOSE"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("SAVE"),
            onPressed: () {
              if (_secondaryConnectionFormKey.currentState.validate()) {
                settingsBloc.add(
                  SettingsUpdateSecondaryConnection(
                    id: id,
                    plexName: plexName,
                    secondaryConnectionAddress: controller.text,
                  ),
                );
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}

Future<bool> _showDeleteServerDialog({
  @required BuildContext context,
  @required String plexName,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text('Are you sure you want to remove $plexName?'),
        actions: <Widget>[
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text('CONFIRM'),
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}
