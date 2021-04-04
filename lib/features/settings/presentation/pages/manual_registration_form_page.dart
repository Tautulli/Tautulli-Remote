import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validators/validators.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/widgets/failure_alert_dialog.dart';
import '../bloc/register_device_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/certificate_failure_alert_dialog.dart';

class ManualRegistrationForm extends StatefulWidget {
  ManualRegistrationForm({Key key}) : super(key: key);

  @override
  _ManualRegistrationFormState createState() => _ManualRegistrationFormState();
}

class _ManualRegistrationFormState extends State<ManualRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _primaryConnectionAddressController =
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
          title: const Text('Manual Device Registration'),
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
          child: Column(
            children: <Widget>[
              BlocBuilder<RegisterDeviceBloc, RegisterDeviceState>(
                builder: (context, state) {
                  if (state is RegisterDeviceInProgress) {
                    return const SizedBox(
                      height: 2,
                      child: LinearProgressIndicator(),
                    );
                  }
                  return Container(height: 2, width: 0);
                },
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _primaryConnectionAddressController,
                        decoration: const InputDecoration(
                            labelText: 'Tautulli Address'),
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
                        controller: _deviceTokenController,
                        decoration:
                            const InputDecoration(labelText: 'Device Token'),
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
                                bool value = await _showExitDialog(context);
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
                                    RegisterDeviceManualStarted(
                                      connectionAddress:
                                          _primaryConnectionAddressController
                                              .text,
                                      deviceToken: _deviceTokenController.text,
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
            const Text('Your current entered information will be discarded.'),
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
