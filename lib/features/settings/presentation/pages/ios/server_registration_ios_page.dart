import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/widgets/ios/ios_bottom_sheet_close_button.dart';
import '../../../../../core/widgets/ios/ios_bottom_sheet_save_button.dart';
import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../data/models/custom_header_model.dart';
import '../../bloc/register_device_bloc.dart';
import '../../bloc/registration_headers_bloc.dart';
import '../../bloc/settings_bloc.dart';
import '../../widgets/ios/dialogs/certificate_failure_ios_dialog.dart';
import '../../widgets/ios/dialogs/registration_exit_ios_dialog.dart';
import '../../widgets/ios/dialogs/registration_failure_ios_dialog.dart';
import '../../widgets/ios/server_registration_ios_step_one.dart';
import '../../widgets/ios/server_registration_ios_step_three.dart';
import '../../widgets/ios/server_registration_ios_step_two.dart';

class ServerRegistrationIosPage extends StatelessWidget {
  const ServerRegistrationIosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<RegisterDeviceBloc>(),
      child: const ServerRegistrationIosView(),
    );
  }
}

class ServerRegistrationIosView extends StatelessWidget {
  const ServerRegistrationIosView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final primaryController = TextEditingController();
    final secondaryController = TextEditingController();
    final tokenController = TextEditingController();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final NavigatorState navigator = Navigator.of(context);
        final bool? shouldPop = await showCupertinoDialog(
          context: context,
          builder: (_) => const RegistrationExitIosDialog(),
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
                    child: const CertificateFailureIosDialog(),
                  );
                },
              );
            } else {
              await showCupertinoDialog(
                context: context,
                builder: (context) => RegistrationFailureIosDialog(
                  failure: state.failure,
                ),
              );
            }
          }
        },
        child: Form(
          key: formKey,
          child: PageScaffoldCupertino(
            showBackButton: false,
            middle: const Text(LocaleKeys.server_registration_title).tr(),
            leading: IosBottomSheetCloseButton(
              onPressed: () async {
                final result = await showCupertinoDialog(
                  context: context,
                  builder: (context) => const RegistrationExitIosDialog(),
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
                return IosBottomSheetSaveButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      context.read<RegisterDeviceBloc>().add(
                        RegisterDeviceStarted(
                          primaryConnectionAddress: primaryController.text,
                          secondaryConnectionAddress: secondaryController.text,
                          deviceToken: tokenController.text,
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
                          settingsBloc: context.read<SettingsBloc>(),
                        ),
                      );
                    }
                  },
                );
              },
            ),
            child: ListView(
              children: [
                const ServerRegistrationIosStepOne(),
                ServerRegistrationIosStepTwo(
                  primaryController: primaryController,
                  secondaryController: secondaryController,
                  tokenController: tokenController,
                ),
                const ServerRegistrationIosStepThree(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
