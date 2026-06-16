import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/widgets/cupertino/buttons/cupertino_style_bottom_sheet_close_button.dart';
import '../../../../../core/widgets/cupertino/buttons/cupertino_style_bottom_sheet_save_button.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_page_scaffold.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../data/models/custom_header_model.dart';
import '../../bloc/register_device_bloc.dart';
import '../../bloc/registration_headers_bloc.dart';
import '../../bloc/settings_bloc.dart';
import '../../widgets/cupertino/dialogs/cupertino_style_certificate_failure_dialog.dart';
import '../../widgets/cupertino/dialogs/cupertino_style_registration_exit_dialog.dart';
import '../../widgets/cupertino/dialogs/cupertino_style_registration_failure_dialog.dart';
import '../../widgets/cupertino/cupertino_style_server_registration_step_one.dart';
import '../../widgets/cupertino/cupertino_style_server_registration_step_three.dart';
import '../../widgets/cupertino/cupertino_style_server_registration_step_two.dart';

class CupertinoStyleServerRegistrationPage extends StatelessWidget {
  const CupertinoStyleServerRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<RegisterDeviceBloc>(param1: context.read<SettingsBloc>()),
      child: const ServerRegistrationIosView(),
    );
  }
}

class ServerRegistrationIosView extends StatefulWidget {
  const ServerRegistrationIosView({super.key});

  @override
  State<ServerRegistrationIosView> createState() => _ServerRegistrationIosViewState();
}

class _ServerRegistrationIosViewState extends State<ServerRegistrationIosView> {
  final _formKey = GlobalKey<FormState>();
  final _primaryController = TextEditingController();
  final _secondaryController = TextEditingController();
  final _tokenController = TextEditingController();

  @override
  void dispose() {
    _primaryController.dispose();
    _secondaryController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final NavigatorState navigator = Navigator.of(context);
        final bool? shouldPop = await showCupertinoDialog(
          context: context,
          builder: (_) => const CupertinoStyleRegistrationExitDialog(),
        );

        if (shouldPop ?? false) {
          context.read<RegistrationHeadersBloc>().add(
            RegistrationHeadersClear(),
          );
          navigator.pop();
        }
      },
      child: BlocListener<RegisterDeviceBloc, RegisterDeviceState>(
        listener: (context, state) async {
          if (state is RegisterDeviceSuccess) {
            if (state.isUpdate) {
              Fluttertoast.showToast(
                backgroundColor: CupertinoColors.systemGreen,
                textColor: CupertinoColors.black,
                toastLength: Toast.LENGTH_LONG,
                msg: LocaleKeys.server_registration_updated_snackbar_message.tr(args: [state.serverName]),
              );
            }

            context.read<RegistrationHeadersBloc>().add(
              RegistrationHeadersClear(),
            );
            Navigator.of(context).pop();
          }
          if (state is RegisterDeviceFailure) {
            if (state.failure == CertificateVerificationFailure()) {
              await showCupertinoDialog(
                context: context,
                builder: (_) {
                  return BlocProvider.value(
                    value: context.read<RegisterDeviceBloc>(),
                    child: const CupertinoStyleCertificateFailureDialog(),
                  );
                },
              );
            } else {
              await showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoStyleRegistrationFailureDialog(
                  failure: state.failure,
                ),
              );
            }
          }
        },
        child: Form(
          key: _formKey,
          child: CupertinoStylePageScaffold(
            showBackButton: false,
            middle: const Text(LocaleKeys.server_registration_title).tr(),
            leading: CupertinoStyleBottomSheetCloseButton(
              onPressed: () async {
                final result = await showCupertinoDialog(
                  context: context,
                  builder: (context) => const CupertinoStyleRegistrationExitDialog(),
                );

                if (result) {
                  context.read<RegistrationHeadersBloc>().add(
                    RegistrationHeadersClear(),
                  );

                  Navigator.of(context).pop();
                }
              },
            ),
            trailing: BlocBuilder<RegistrationHeadersBloc, RegistrationHeadersState>(
              builder: (context, state) {
                return CupertinoStyleBottomSheetSaveButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<RegisterDeviceBloc>().add(
                        RegisterDeviceStarted(
                          primaryConnectionAddress: _primaryController.text,
                          secondaryConnectionAddress: _secondaryController.text,
                          deviceToken: _tokenController.text,
                          headers: state is RegistrationHeadersLoaded
                              ? state.headers
                                    .map(
                                      (header) => CustomHeaderModel(
                                        key: header.key,
                                        value: header.value,
                                      ),
                                    )
                                    .toList()
                              : [],
                        ),
                      );
                    }
                  },
                );
              },
            ),
            child: ListView(
              children: [
                const CupertinoStyleServerRegistrationStepOne(),
                CupertinoStyleServerRegistrationStepTwo(
                  primaryController: _primaryController,
                  secondaryController: _secondaryController,
                  tokenController: _tokenController,
                ),
                const CupertinoStyleServerRegistrationStepThree(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
