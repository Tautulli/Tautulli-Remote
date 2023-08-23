import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:validators/validators.dart';

import '../../../../core/qr_code_scanner/qr_code_scanner.dart';
import '../../../../core/widgets/themed_text_form_field.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import 'dialogs/secondary_connection_address_info_dialog.dart';
import 'registration_instruction.dart';

class ServerRegistrationStepTwo extends StatefulWidget {
  final TextEditingController primaryController;
  final TextEditingController secondaryController;
  final TextEditingController tokenController;

  const ServerRegistrationStepTwo({
    super.key,
    required this.primaryController,
    required this.secondaryController,
    required this.tokenController,
  });

  @override
  State<ServerRegistrationStepTwo> createState() => ServerRegistrationStepTwoState();
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
      heading: '${LocaleKeys.step_title.tr()} 2',
      action: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              child: const Text(LocaleKeys.scan_qr_code_title).tr(),
              onPressed: () async {
                try {
                  final qrCodeScan = await di.sl<QrCodeScanner>().scan(context);
                  if (qrCodeScan != null) {
                    widget.primaryController.text = qrCodeScan.value1;
                    widget.tokenController.text = qrCodeScan.value2;
                  }
                } catch (_) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      content: Text(
                        LocaleKeys.qr_code_scan_error_snackbar_message,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onError,
                        ),
                      ).tr(),
                    ),
                  );
                }
              },
            ),
          ),
          Text(
            'or',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const Gap(4),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(8),
          ThemedTextFormField(
            controller: widget.primaryController,
            focusNode: _primaryFocus,
            labelText: '${LocaleKeys.primary_connection_address_title.tr()}${!_primaryValid ? '*' : ''}',
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
                return LocaleKeys.server_connection_address_dialog_primary_validation.tr();
              }
              setState(() {
                _primaryValid = true;
              });
              return null;
            },
          ),
          const Gap(16),
          ThemedTextFormField(
            controller: widget.secondaryController,
            focusNode: _secondaryFocus,
            labelText: '${LocaleKeys.secondary_connection_address_title.tr()}${!_secondaryValid ? '*' : ''}',
            suffixIcon: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.solidCircleQuestion,
                  ),
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return const SecondaryConnectionAddressInfoDialog();
                      },
                    );
                  },
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
                return LocaleKeys.server_connection_address_dialog_secondary_validation.tr();
              }
              setState(() {
                _secondaryValid = true;
              });
              return null;
            },
          ),
          const Gap(16),
          ThemedTextFormField(
            controller: widget.tokenController,
            focusNode: _tokenFocus,
            labelText: '${LocaleKeys.device_token_title.tr()}${!_tokenValid ? '*' : ''}',
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
                return LocaleKeys.device_token_validation.tr(args: [value.length.toString()]);
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
