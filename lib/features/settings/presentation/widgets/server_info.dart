import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import '../../../onesignal/presentation/bloc/onesignal_subscription_bloc.dart';
import '../../domain/entities/settings.dart';
import '../bloc/register_device_bloc.dart';
import '../bloc/settings_bloc.dart';
import 'server_setup_instructions.dart';

class ServerInfo extends StatelessWidget {
  final Settings settings;

  const ServerInfo({
    Key key,
    @required this.settings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final registerDeviceBloc = BlocProvider.of<RegisterDeviceBloc>(context);
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BlocBuilder<RegisterDeviceBloc, RegisterDeviceState>(
            builder: (context, state) {
              //TODO: registerDeviceInProgress can get stuck if the qr scanner is backed out of
              // if (state is RegisterDeviceInProgress) {
              //   return Center(
              //     child: CircularProgressIndicator(),
              //   );
              // }
              // if both connectionAddress and deviceToken are not null and not empty strings display them
              return (settings.connectionAddress != null &&
                      settings.connectionAddress != '' &&
                      settings.deviceToken != null &&
                      settings.deviceToken != '')
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Connection Address'),
                        (settings.connectionAddress != null &&
                                settings.connectionAddress != '')
                            ? Text(
                                settings.connectionAddress,
                                style: TextStyle(color: Colors.grey[350]),
                              )
                            : Text(
                                'Required',
                                style: TextStyle(color: Colors.grey[350]),
                              ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Device Token'),
                        (settings.deviceToken != null &&
                                settings.deviceToken != '')
                            ? Text(
                                settings.deviceToken,
                                style: TextStyle(color: Colors.grey[350]),
                              )
                            : Text(
                                'Required',
                                style: TextStyle(color: Colors.grey[350]),
                              ),
                      ],
                    )
                  : ServerSetupInstructions();
            },
          ),
          BlocBuilder<OneSignalSubscriptionBloc, OneSignalSubscriptionState>(
            builder: (context, state) {
              if (state is OneSignalSubscriptionFailure) {
                return Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        state.title,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        state.message,
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Container(height: 0, width: 0);
            },
          ),
          BlocBuilder<OneSignalPrivacyBloc, OneSignalPrivacyState>(
            builder: (context, state) {
              if (state is OneSignalPrivacyConsentFailure) {
                return Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: RaisedButton.icon(
                    icon: FaIcon(FontAwesomeIcons.userSecret),
                    label: Text('OneSignal Data Privacy'),
                    color: PlexColorPalette.curious_blue,
                    onPressed: () async {
                      Navigator.of(context).pushNamed('/privacy');
                    },
                  ),
                );
              }
              return Container(height: 0, width: 0);
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: RaisedButton.icon(
              icon: FaIcon(FontAwesomeIcons.qrcode),
              label: Text('Register with Tautulli'),
              color: Theme.of(context).accentColor,
              onPressed: () async {
                final qrCodeScan = await FlutterBarcodeScanner.scanBarcode(
                  '#e5a00d',
                  'Cancel',
                  false,
                  ScanMode.QR,
                );
                // Passes in the SettingsBloc to maintain context so items update correctly
                registerDeviceBloc.add(
                  RegisterDeviceStarted(
                    result: qrCodeScan,
                    settingsBloc: settingsBloc,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
