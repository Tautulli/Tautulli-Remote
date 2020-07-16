import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/settings_bloc.dart';
import '../widgets/settings_header.dart';

class AdvancedServerSettingsPage extends StatelessWidget {
  const AdvancedServerSettingsPage({Key key}) : super(key: key);

  static const routeName = '/advanced_server_settings';

  @override
  Widget build(BuildContext context) {
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    final urlController = TextEditingController();
    final deviceTokenController = TextEditingController();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Advanced Server Settings'),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoadSuccess) {
            return ListView(
              children: <Widget>[
                // SizedBox(
                //   height: 20,
                // ),
                // SettingsHeader(
                //   headingText: 'Primary Connection',
                // ),
                ListTile(
                  title: Text('Primary Connection Address'),
                  subtitle: state.settings.connectionAddress != null &&
                          state.settings.connectionAddress != ''
                      ? Text(state.settings.connectionAddress)
                      : Text('Required'),
                  onTap: () {
                    return _buildConnectionAddressSettingsDialog(
                      context: context,
                      state: state,
                      controller: urlController,
                      settingsBloc: settingsBloc,
                    );
                  },
                ),
                ListTile(
                  title: Text('Device Token'),
                  subtitle: state.settings.deviceToken != null &&
                          state.settings.deviceToken != ''
                      ? Text(state.settings.deviceToken)
                      : Text('Required'),
                  onTap: () {
                    return _buildDeviceTokenSettingsDialog(
                      context: context,
                      state: state,
                      controller: deviceTokenController,
                      settingsBloc: settingsBloc,
                    );
                  },
                ),
              ],
            );
          } else {
            //TODO: Handle if the settings state is something other than Loaded
            return Text('Something went wrong loading settings');
          }
        },
      ),
    );
  }

  Future _buildConnectionAddressSettingsDialog({
    @required BuildContext context,
    @required SettingsLoadSuccess state,
    @required TextEditingController controller,
    @required SettingsBloc settingsBloc,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        if (state.settings.connectionAddress != null) {
          controller.text = state.settings.connectionAddress;
        }
        return AlertDialog(
          title: Text('Tautulli Connection Address'),
          content: TextFormField(
            controller: controller,
            decoration:
                InputDecoration(hintText: 'Input your connection address'),
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
                settingsBloc.add(SettingsUpdateConnection(value: controller.text));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future _buildDeviceTokenSettingsDialog({
    @required BuildContext context,
    @required SettingsLoadSuccess state,
    @required TextEditingController controller,
    @required SettingsBloc settingsBloc,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        if (state.settings.deviceToken != null) {
          controller.text = state.settings.deviceToken;
        }
        return AlertDialog(
          title: Text('Tautulli Device Token'),
          content: TextFormField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Input your device token'),
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
                settingsBloc.add(SettingsUpdateDeviceToken(value: controller.text));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
