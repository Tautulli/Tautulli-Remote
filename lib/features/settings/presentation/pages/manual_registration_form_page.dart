import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validators/validators.dart';

import '../../../../core/widgets/failure_alert_dialog.dart';
import '../bloc/register_device_bloc.dart';
import '../bloc/settings_bloc.dart';

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
    final registerDeviceBloc = BlocProvider.of<RegisterDeviceBloc>(context);

    return WillPopScope(
      onWillPop: () async {
        // Make user confirm exit
        return _showExitDialog(context);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text('Manual Device Registration'),
        ),
        body: BlocListener<RegisterDeviceBloc, RegisterDeviceState>(
          listener: (context, state) {
            if (state is RegisterDeviceFailure) {
              //TODO: add a link to a wiki page for registration
              showFailureAlertDialog(
                context: context,
                failure: state.failure,
              );
            }
            if (state is RegisterDeviceSuccess) {
              Navigator.of(context).pop(true);
            }
          },
          //TODO: Could be nice to add some extra instructions here maybe?
          child: Column(
            children: <Widget>[
              BlocBuilder<RegisterDeviceBloc, RegisterDeviceState>(
                builder: (context, state) {
                  if (state is RegisterDeviceInProgress) {
                    return SizedBox(
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
                        decoration:
                            InputDecoration(labelText: 'Tautulli Address'),
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
                        decoration: InputDecoration(labelText: 'Device Token'),
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
                            FlatButton(
                              onPressed: () async {
                                bool value = await _showExitDialog(context);
                                if (value) {
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Text('Cancel'),
                            ),
                            FlatButton(
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  registerDeviceBloc.add(
                                    RegisterDeviceManualStarted(
                                      connectionAddress:
                                          _primaryConnectionAddressController
                                              .text,
                                      deviceToken: _deviceTokenController.text,
                                      settingsBloc:
                                          BlocProvider.of<SettingsBloc>(
                                              context),
                                    ),
                                  );
                                }
                              },
                              child: Text('Register'),
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
        title: Text('Are you sure you want to exit?'),
        content: Text('Your current entered information will be discarded.'),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          FlatButton(
            child: Text('Discard'),
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
