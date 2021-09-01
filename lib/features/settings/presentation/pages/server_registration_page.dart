// @dart=2.9

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validators/validators.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/failure_alert_dialog.dart';
import '../../../../translations/locale_keys.g.dart';
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
                  showHelp: true,
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
                              LocaleKeys.settings_registration_text_1.tr(),
                              style: TextStyle(
                                fontSize: widget.fontSize,
                                color: TautulliColorPalette.not_white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              LocaleKeys.settings_registration_text_2.tr(),
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
                                    LocaleKeys.button_cancel.tr(),
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
                                            LocaleKeys
                                                .settings_registration_qr_error,
                                          ).tr(),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: const Text(LocaleKeys
                                        .settings_registration_scan_code)
                                    .tr(),
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
                                autocorrect: false,
                                decoration: InputDecoration(
                                  labelText: LocaleKeys
                                      .settings_primary_connection_address
                                      .tr(),
                                  labelStyle: const TextStyle(
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
                                    return LocaleKeys
                                        .settings_connection_address_validation_message
                                        .tr();
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller:
                                    _secondaryConnectionAddressController,
                                autocorrect: false,
                                decoration: InputDecoration(
                                  labelText: LocaleKeys
                                      .settings_secondary_connection_address
                                      .tr(),
                                  labelStyle: const TextStyle(
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
                                    return LocaleKeys
                                        .settings_connection_address_validation_message
                                        .tr();
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _deviceTokenController,
                                autocorrect: false,
                                decoration: InputDecoration(
                                  labelText:
                                      LocaleKeys.settings_device_token.tr(),
                                  labelStyle: const TextStyle(
                                    color: TautulliColorPalette.not_white,
                                  ),
                                ),
                                style: const TextStyle(
                                  color: TautulliColorPalette.not_white,
                                ),
                                validator: (value) {
                                  if (value.length != 32) {
                                    return LocaleKeys
                                        .settings_device_token_validation_message
                                        .tr(
                                      args: [value.length.toString()],
                                    );
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
                                      child:
                                          const Text(LocaleKeys.button_cancel)
                                              .tr(),
                                    ),
                                    BlocBuilder<SettingsBloc, SettingsState>(
                                      builder: (context, state) {
                                        return TextButton(
                                          onPressed: () async {
                                            if (state is SettingsLoadSuccess) {
                                              if (_formKey.currentState
                                                  .validate()) {
                                                // final url =
                                                //     _primaryConnectionAddressController
                                                //         .text;
                                                // final host =
                                                //     ConnectionAddressHelper
                                                //         .parse(url)['domain'];
                                                // final ipAddress =
                                                //     IpAddressHelper
                                                //         .parseIpFromUrl(url);

                                                // final bool isPrivateIp =
                                                //     (ipAddress != '' &&
                                                //             !IpAddressHelper
                                                //                 .isPublic(
                                                //                     ipAddress)) ||
                                                //         !await IpAddressHelper
                                                //             .hostResolvesToPublic(
                                                //                 host);

                                                // if (Platform.isIOS &&
                                                //     isPrivateIp &&
                                                //     !state
                                                //         .iosLocalNetworkPermissionPrompted) {
                                                //   await showLocalNetworkPermissionDialog(
                                                //     context: context,
                                                //     ipAddress: ipAddress,
                                                //   );
                                                // } else {
                                                registerDeviceBloc.add(
                                                  RegisterDeviceStarted(
                                                    primaryConnectionAddress:
                                                        _primaryConnectionAddressController
                                                            .text,
                                                    secondaryConnectionAddress:
                                                        _secondaryConnectionAddressController
                                                            .text,
                                                    deviceToken:
                                                        _deviceTokenController
                                                            .text,
                                                    settingsBloc: context
                                                        .read<SettingsBloc>(),
                                                  ),
                                                );
                                                // }
                                              }
                                            }
                                          },
                                          child: Text(
                                            LocaleKeys.button_register,
                                            style: TextStyle(
                                              color:
                                                  state is SettingsLoadSuccess
                                                      ? TautulliColorPalette
                                                          .not_white
                                                      : Colors.grey,
                                            ),
                                          ).tr(),
                                        );
                                      },
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
        title:
            const Text(LocaleKeys.settings_registration_exit_dialog_title).tr(),
        content:
            const Text(LocaleKeys.settings_registration_exit_dialog_content)
                .tr(),
        actions: <Widget>[
          TextButton(
            child: const Text(LocaleKeys.button_cancel).tr(),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text(LocaleKeys.button_discard).tr(),
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
