import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:validators/validators.dart';

import '../../../../core/qr_code_scanner/qr_code_scanner.dart';
import '../../../../dependency_injection.dart' as di;
import 'registration_instruction.dart';

class ServerRegistrationStepTwo extends StatefulWidget {
  final TextEditingController primaryController;
  final TextEditingController secondaryController;
  final TextEditingController tokenController;

  const ServerRegistrationStepTwo({
    Key? key,
    required this.primaryController,
    required this.secondaryController,
    required this.tokenController,
  }) : super(key: key);

  @override
  State<ServerRegistrationStepTwo> createState() =>
      ServerRegistrationStepTwoState();
}

class ServerRegistrationStepTwoState extends State<ServerRegistrationStepTwo> {
  bool _primaryValid = true;
  bool _secondaryValid = true;
  bool _tokenValid = true;
  final _primaryFocus = FocusNode();
  final _secondaryFocus = FocusNode();
  final _tokenFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return RegistrationInstruction(
      actionOnTop: true,
      heading: 'Step 2',
      action: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  child: const Text('Scan QR Code'),
                  onPressed: () async {
                    try {
                      final qrCodeScan = await di.sl<QrCodeScanner>().scan();
                      if (qrCodeScan != null) {
                        widget.primaryController.text = qrCodeScan.value1;
                        widget.tokenController.text = qrCodeScan.value2;
                      }
                    } catch (_) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Theme.of(context).errorColor,
                          content: const Text(
                            'Error scanning QR code',
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          Text(
            'or',
            style: Theme.of(context).textTheme.subtitle2,
          ),
          const Gap(4),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(8),
          TextFormField(
            controller: widget.primaryController,
            focusNode: _primaryFocus,
            autocorrect: false,
            decoration: InputDecoration(
              labelText:
                  'Primary Connection Address${!_primaryValid ? '*' : ''}',
              labelStyle: TextStyle(
                color: _primaryValid
                    ? Theme.of(context).inputDecorationTheme.labelStyle!.color
                    : Theme.of(context).colorScheme.error,
              ),
              floatingLabelStyle: TextStyle(
                color: !_primaryValid
                    ? Theme.of(context).colorScheme.error
                    : _primaryFocus.hasFocus
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context)
                            .inputDecorationTheme
                            .enabledBorder!
                            .borderSide
                            .color,
              ),
            ),
            onTap: () {
              setState(() {
                FocusScope.of(context).requestFocus(_primaryFocus);
              });
            },
            validator: (value) {
              bool validUrl = isURL(
                value,
                protocols: ['http', 'https'],
                requireProtocol: true,
              );

              if (!validUrl) {
                setState(() {
                  _primaryValid = false;
                });
                return 'Enter a valid URL format';
              }
              setState(() {
                _primaryValid = true;
              });
              return null;
            },
          ),
          const Gap(16),
          TextFormField(
            controller: widget.secondaryController,
            focusNode: _secondaryFocus,
            autocorrect: false,
            decoration: InputDecoration(
              labelText:
                  'Secondary Connection Address${!_secondaryValid ? '*' : ''}',
              labelStyle: TextStyle(
                color: _secondaryValid
                    ? Theme.of(context).inputDecorationTheme.labelStyle!.color
                    : Theme.of(context).colorScheme.error,
              ),
              floatingLabelStyle: TextStyle(
                color: !_secondaryValid
                    ? Theme.of(context).colorScheme.error
                    : _secondaryFocus.hasFocus
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context)
                            .inputDecorationTheme
                            .enabledBorder!
                            .borderSide
                            .color,
              ),
              suffixIcon: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.solidQuestionCircle,
                    ),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              'Secondary Connection Address',
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'The Secondary Connection Address will be used if the Primary Connection Address is unreachable.',
                                ),
                                Gap(8),
                                Text(
                                  'This is particularly useful if your public IP address is not accessible inside your network.',
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                child: const Text('CLOSE'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            onTap: () {
              setState(() {
                FocusScope.of(context).requestFocus(_secondaryFocus);
              });
            },
            validator: (value) {
              bool validUrl = isURL(
                value,
                protocols: ['http', 'https'],
                requireProtocol: true,
              );

              if (value != '' && !validUrl) {
                setState(() {
                  _secondaryValid = false;
                });
                return 'Leave blank or enter a valid URL format';
              }
              setState(() {
                _secondaryValid = true;
              });
              return null;
            },
          ),
          const Gap(16),
          TextFormField(
            controller: widget.tokenController,
            focusNode: _tokenFocus,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: 'Device Token${!_tokenValid ? '*' : ''}',
              labelStyle: TextStyle(
                color: _tokenValid
                    ? Theme.of(context).inputDecorationTheme.labelStyle!.color
                    : Theme.of(context).colorScheme.error,
              ),
              floatingLabelStyle: TextStyle(
                color: !_tokenValid
                    ? Theme.of(context).colorScheme.error
                    : _tokenFocus.hasFocus
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context)
                            .inputDecorationTheme
                            .enabledBorder!
                            .borderSide
                            .color,
              ),
            ),
            onTap: () {
              setState(() {
                FocusScope.of(context).requestFocus(_tokenFocus);
              });
            },
            validator: (value) {
              if (value != null && value.length != 32) {
                setState(() {
                  _tokenValid = false;
                });
                return 'Must be 32 characters long (current: ${value.length.toString()})';
              }
              setState(() {
                _tokenValid = true;
              });
              return null;
            },
          ),
          const Gap(4),
        ],
      ),
    );
  }
}
