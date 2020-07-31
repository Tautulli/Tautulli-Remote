import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiver/strings.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../bloc/settings_bloc.dart';

class ServerSettings extends StatelessWidget {
  final int id;
  final String plexName;

  const ServerSettings({
    Key key,
    @required this.id,
    @required this.plexName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    final _primaryConnectionAddressController = TextEditingController();
    final _secondaryConnectionAddressController = TextEditingController();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('$plexName Settings'),
        actions: <Widget>[
          IconButton(
            icon: FaIcon(FontAwesomeIcons.trashAlt),
            onPressed: () async {
              bool delete = await _showDeleteServerDialog(
                context: context,
                plexName: plexName,
              );
              if (delete) {
                settingsBloc.add(SettingsDeleteServer(id: id));
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
                    title: Text('Primary Connection Address'),
                    subtitle: Text(server.primaryConnectionAddress),
                    onTap: () {
                      _buildPrimaryConnectionAddressSettingsDialog(
                        context: context,
                        id: server.id,
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
                        Scaffold.of(context).hideCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: PlexColorPalette.shark,
                            content: Text('Copied to clipboard'),
                          ),
                        );
                      }
                    },
                  ),
                  ListTile(
                    title: Text('Secondary Connection Address'),
                    subtitle: isNotEmpty(server.secondaryConnectionAddress)
                        ? Text(server.secondaryConnectionAddress)
                        : Text('Not configured'),
                    onTap: () {
                      _buildSecondaryConnectionAddressSettingsDialog(
                        context: context,
                        id: server.id,
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
                        Scaffold.of(context).hideCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: PlexColorPalette.shark,
                            content: Text('Copied to clipboard'),
                          ),
                        );
                      }
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Device Token',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    subtitle: Text(
                      server.deviceToken,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    onTap: () {
                      Scaffold.of(context).hideCurrentSnackBar();
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: PlexColorPalette.shark,
                          //TODO: Add link to wiki page about this
                          content: Text('Device tokens cannot be edited'),
                        ),
                      );
                    },
                    onLongPress: () {
                      if (isNotEmpty(server.deviceToken)) {
                        Clipboard.setData(
                          ClipboardData(text: server.deviceToken),
                        );
                        Scaffold.of(context).hideCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: PlexColorPalette.shark,
                            content: Text('Copied to clipboard'),
                          ),
                        );
                      }
                    },
                  ),
                ],
              );
            } catch (error) {
              return Text('Server not found in settings');
            }
          }
          return Text('Bloc error');
        },
      ),
    );
  }
}

Future _buildPrimaryConnectionAddressSettingsDialog({
  @required BuildContext context,
  @required int id,
  @required String primaryConnectionAddress,
  @required TextEditingController controller,
  @required SettingsBloc settingsBloc,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      if (primaryConnectionAddress != null) {
        controller.text = primaryConnectionAddress;
      }
      //TODO: Need to add instructions on how the connection address works
      return AlertDialog(
        title: Text('Tautulli Primary Connection Address'),
        content: TextFormField(
          controller: controller,
          decoration: InputDecoration(
              hintText: 'Input your primary connection address'),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text("Save"),
            onPressed: () {
              settingsBloc.add(
                SettingsUpdatePrimaryConnection(
                  id: id,
                  primaryConnectionAddress: controller.text,
                ),
              );
              Navigator.of(context).pop();
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
  @required String secondaryConnectionAddress,
  @required TextEditingController controller,
  @required SettingsBloc settingsBloc,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      if (secondaryConnectionAddress != null) {
        controller.text = secondaryConnectionAddress;
      }
      //TODO: Need to add instructions on how the secondary connection address works
      return AlertDialog(
        title: Text('Tautulli Secondary Connection Address'),
        content: TextFormField(
          controller: controller,
          decoration: InputDecoration(
              hintText: 'Input your secondary connection address'),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text("Save"),
            onPressed: () {
              settingsBloc.add(
                SettingsUpdateSecondaryConnection(
                  id: id,
                  secondaryConnectionAddress: controller.text,
                ),
              );
              Navigator.of(context).pop();
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
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          FlatButton(
            child: Text('Confirm'),
            color: Colors.red,
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}
