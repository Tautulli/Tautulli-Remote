import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:validators/validators.dart';

import '../../../../../core/qr_code_scanner/qr_code_scanner.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_card.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import 'dialogs/cupertino_style_secondary_connection_address_info_dialog.dart';

class CupertinoStyleServerRegistrationStepTwo extends StatefulWidget {
  final TextEditingController primaryController;
  final TextEditingController secondaryController;
  final TextEditingController tokenController;

  const CupertinoStyleServerRegistrationStepTwo({
    super.key,
    required this.primaryController,
    required this.secondaryController,
    required this.tokenController,
  });

  @override
  State<CupertinoStyleServerRegistrationStepTwo> createState() => _CupertinoStyleServerRegistrationStepTwoState();
}

class _CupertinoStyleServerRegistrationStepTwoState extends State<CupertinoStyleServerRegistrationStepTwo> {
  final _primaryFocus = FocusNode();
  final _secondaryFocus = FocusNode();
  final _tokenFocus = FocusNode();

  @override
  void dispose() {
    _primaryFocus.dispose();
    _secondaryFocus.dispose();
    _tokenFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return Column(
      children: [
        CupertinoStyleListSection(
          headerText: '${LocaleKeys.step_title.tr()} 2',
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CupertinoButton.filled(
            child: const Text(LocaleKeys.scan_qr_code_title).tr(),
            onPressed: () async {
              try {
                final qrCodeScan = await di.sl<QrCodeScanner>().scan();
                if (qrCodeScan != null) {
                  widget.primaryController.text = qrCodeScan.value1;
                  widget.tokenController.text = qrCodeScan.value2;
                }
              } catch (_) {
                Fluttertoast.showToast(
                  backgroundColor: CupertinoColors.destructiveRed,
                  textColor: CupertinoColors.black,
                  toastLength: Toast.LENGTH_LONG,
                  msg: LocaleKeys.qr_code_scan_error_snackbar_message.tr(),
                );
              }
            },
          ),
        ),
        const Gap(4),
        const Text(LocaleKeys.or).tr(),
        const Gap(4),
        CupertinoStyleCard(
          horizontalPadding: 20,
          child: CupertinoFormSection.insetGrouped(
            margin: const EdgeInsetsGeometry.all(0),
            children: [
              CupertinoTextFormFieldRow(
                controller: widget.primaryController,
                focusNode: _primaryFocus,
                autocorrect: false,
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
                    allowUnderscore: true,
                  );

                  if (!validUrl) {
                    return LocaleKeys.server_connection_address_dialog_primary_validation.tr();
                  }

                  return null;
                },
                placeholder: LocaleKeys.primary_connection_address_title.tr(),
              ),
              Stack(
                children: [
                  CupertinoTextFormFieldRow(
                    controller: widget.secondaryController,
                    focusNode: _secondaryFocus,
                    autocorrect: false,
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
                        allowUnderscore: true,
                      );

                      if (value != '' && !validUrl) {
                        return LocaleKeys.server_connection_address_dialog_secondary_validation.tr();
                      }

                      return null;
                    },
                    placeholder: LocaleKeys.secondary_connection_address_title.tr(),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: CupertinoButton(
                      child: const Icon(CupertinoIcons.question_circle_fill),
                      onPressed: () => showCupertinoDialog(
                        context: context,
                        builder: (context) => const CupertinoStyleSecondaryConnectionAddressInfoDialog(),
                      ),
                    ),
                  ),
                ],
              ),
              CupertinoTextFormFieldRow(
                controller: widget.tokenController,
                focusNode: _tokenFocus,
                autocorrect: false,
                placeholder: LocaleKeys.device_token_title.tr(),
                onTap: () {
                  setState(() {
                    FocusScope.of(context).requestFocus(_tokenFocus);
                  });
                },
                validator: (value) {
                  if (value != null && value.length != 32) {
                    return LocaleKeys.device_token_validation.tr(args: [value.length.toString()]);
                  }

                  return null;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
