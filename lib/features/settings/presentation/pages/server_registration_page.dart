import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validators/validators.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/failure_alert_dialog.dart';
import '../bloc/register_device_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/certificate_failure_alert_dialog.dart';

class ServerRegistrationPage extends StatefulWidget {
  final double fontSize;

  ServerRegistrationPage({
    Key key,
    this.fontSize = 16,
  }) : super(key: key);

  @override
  _ServerRegistrationPageState createState() => _ServerRegistrationPageState();
}

class _ServerRegistrationPageState extends State<ServerRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _primaryConnectionAddressController =
      TextEditingController();
  TextEditingController _secondaryConnectionAddressController =
      TextEditingController();
  TextEditingController _deviceTokenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final registerDeviceBloc = context.read<RegisterDeviceBloc>();

    return WillPopScope(
      onWillPop: () async {
        // Make user confirm exit
        return _showExitDialog(context);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: const Text('Register a Tautulli Server'),
        ),
        body: BlocListener<RegisterDeviceBloc, RegisterDeviceState>(
          listener: (context, state) {
            if (state is RegisterDeviceFailure) {
              if (state.failure == CertificateVerificationFailure()) {
                showCertificateFailureAlertDialog(
                  context: context,
                  registerDeviceBloc: registerDeviceBloc,
                  settingsBloc: context.read<SettingsBloc>(),
                );
              } else {
                showFailureAlertDialog(
                  context: context,
                  failure: state.failure,
                );
              }
            }
            if (state is RegisterDeviceSuccess) {
              Navigator.of(context).pop(true);
            }
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocBuilder<RegisterDeviceBloc, RegisterDeviceState>(
                  builder: (context, state) {
                    if (state is RegisterDeviceInProgress) {
                      return SizedBox(
                        height: 2,
                        child: LinearProgressIndicator(
                          color: Theme.of(context).accentColor,
                        ),
                      );
                    }
                    return Container(height: 2, width: 0);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                          bottom: 8,
                          left: 8,
                          right: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Use the button below to scan your QR code and auto-fill your server information or enter it manually instead.',
                              style: TextStyle(
                                fontSize: widget.fontSize,
                                color: TautulliColorPalette.not_white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Optionally, you can add a Secondary Connection Address. If the Primary Connection Address is unreachable, the app will automatically use the secondary address.',
                              style: TextStyle(
                                fontSize: widget.fontSize,
                                color: TautulliColorPalette.not_white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        indent: 2,
                        endIndent: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                          left: 8,
                          bottom: 8,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  final qrCodeScan =
                                      await FlutterBarcodeScanner.scanBarcode(
                                    '#e5a00d',
                                    'Cancel',
                                    false,
                                    ScanMode.QR,
                                  );

                                  if (qrCodeScan != '-1') {
                                    try {
                                      final List resultParts =
                                          qrCodeScan.split('|');

                                      _primaryConnectionAddressController.text =
                                          resultParts[0].trim();
                                      _deviceTokenController.text =
                                          resultParts[1].trim();
                                    } catch (_) {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor:
                                              Theme.of(context).errorColor,
                                          content: const Text(
                                            'Error scanning QR code',
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: const Text('Scan QR Code'),
                                style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context).accentColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _primaryConnectionAddressController,
                                decoration: const InputDecoration(
                                  labelText: 'Primary Connection Address',
                                  labelStyle: TextStyle(
                                    color: TautulliColorPalette.not_white,
                                  ),
                                ),
                                style: const TextStyle(
                                  color: TautulliColorPalette.not_white,
                                ),
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
                              TextFormField(
                                controller:
                                    _secondaryConnectionAddressController,
                                decoration: const InputDecoration(
                                  labelText: 'Secondary Connection Address',
                                  labelStyle: TextStyle(
                                    color: TautulliColorPalette.not_white,
                                  ),
                                ),
                                style: const TextStyle(
                                  color: TautulliColorPalette.not_white,
                                ),
                                validator: (value) {
                                  bool validUrl = value == '' ||
                                      isURL(
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
                              TextFormField(
                                controller: _deviceTokenController,
                                decoration: const InputDecoration(
                                  labelText: 'Device Token',
                                  labelStyle: TextStyle(
                                    color: TautulliColorPalette.not_white,
                                  ),
                                ),
                                style: const TextStyle(
                                  color: TautulliColorPalette.not_white,
                                ),
                                validator: (value) {
                                  if (value.length != 32) {
                                    return 'Must be 32 characters long (current: ${value.length})';
                                  }
                                  return null;
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    TextButton(
                                      onPressed: () async {
                                        bool value =
                                            await _showExitDialog(context);
                                        if (value) {
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      child: const Text('CANCEL'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          registerDeviceBloc.add(
                                            RegisterDeviceStarted(
                                              primaryConnectionAddress:
                                                  _primaryConnectionAddressController
                                                      .text,
                                              secondaryConnectionAddress:
                                                  _secondaryConnectionAddressController
                                                      .text,
                                              deviceToken:
                                                  _deviceTokenController.text,
                                              settingsBloc:
                                                  context.read<SettingsBloc>(),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text('REGISTER'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> _showExitDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text('Are you sure you want to exit?'),
        content:
            const Text('Any currently entered information will be discarded.'),
        actions: <Widget>[
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text('DISCARD'),
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
