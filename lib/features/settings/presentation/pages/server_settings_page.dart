import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiver/strings.dart';
import 'package:validators/validators.dart';

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
                    subtitle: isNotEmpty(server.primaryConnectionAddress)
                        ? Text(server.primaryConnectionAddress)
                        : Text('Required'),
                    trailing: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.5,
                          color: server.primaryActive
                              ? Colors.green
                              : Colors.grey[700],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      child: Text(
                        isNotEmpty(server.primaryConnectionAddress) &&
                                server.primaryActive
                            ? 'Active'
                            : isNotEmpty(server.primaryConnectionAddress)
                                ? 'Inactive'
                                : 'Disabled',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: server.primaryActive
                              ? Colors.green
                              : Colors.grey[700],
                        ),
                      ),
                    ),
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
                    trailing: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.5,
                          color: !server.primaryActive
                              ? Colors.green
                              : Colors.grey[700],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      child: Text(
                        isEmpty(server.secondaryConnectionAddress)
                            ? 'Disabled'
                            : !server.primaryActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: !server.primaryActive
                              ? Colors.green
                              : Colors.grey[700],
                        ),
                      ),
                    ),
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
              return Text('Server not found in settings [$error]');
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
      final _primaryConnectionFormKey = GlobalKey<FormState>();

      if (primaryConnectionAddress != null) {
        controller.text = primaryConnectionAddress;
      }
      return AlertDialog(
        title: Text('Tautulli Primary Connection Address'),
        content: Form(
          key: _primaryConnectionFormKey,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
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
          FlatButton(
            child: Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text("Save"),
            onPressed: () {
              if (_primaryConnectionFormKey.currentState.validate()) {
                settingsBloc.add(
                  SettingsUpdatePrimaryConnection(
                    id: id,
                    primaryConnectionAddress: controller.text,
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
        title: Text('Tautulli Secondary Connection Address'),
        content: Form(
          key: _secondaryConnectionFormKey,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
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
          FlatButton(
            child: Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text("Save"),
            onPressed: () {
              if (_secondaryConnectionFormKey.currentState.validate()) {
                settingsBloc.add(
                  SettingsUpdateSecondaryConnection(
                    id: id,
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
