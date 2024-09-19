import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../data/models/custom_header_model.dart';
import '../bloc/register_device_bloc.dart';
import '../bloc/registration_headers_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/dialogs/certificate_failure_dialog.dart';
import '../widgets/dialogs/registration_exit_dialog.dart';
import '../widgets/dialogs/registration_failure_dialog.dart';
import '../widgets/server_registration_step_one.dart';
import '../widgets/server_registration_step_three.dart';
import '../widgets/server_registration_step_two.dart';

class ServerRegistrationPage extends StatelessWidget {
  const ServerRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<RegisterDeviceBloc>(),
      child: const ServerRegistrationView(),
    );
  }
}

class ServerRegistrationView extends StatelessWidget {
  const ServerRegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final primaryController = TextEditingController();
    final secondaryController = TextEditingController();
    final tokenController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(LocaleKeys.server_registration_title).tr(),
      ),
      floatingActionButton: BlocBuilder<RegistrationHeadersBloc, RegistrationHeadersState>(
        builder: (context, state) {
          return FloatingActionButton.extended(
            icon: const FaIcon(
              FontAwesomeIcons.solidClipboard,
              size: 20,
            ),
            label: const Text(LocaleKeys.register_server_title).tr(),
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
                                  (widget) => CustomHeaderModel(
                                    key: widget.title,
                                    value: widget.subtitle,
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
      body: PageBody(
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;

            final NavigatorState navigator = Navigator.of(context);
            final bool? shouldPop = await showDialog(
              context: context,
              builder: (_) {
                return const RegistrationExitDialog();
              },
            );

            if (shouldPop ?? false) {
              navigator.pop();
            }
          },
          child: BlocListener<RegisterDeviceBloc, RegisterDeviceState>(
            listener: (context, state) async {
              if (state is RegisterDeviceSuccess) {
                if (state.isUpdate) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green[700],
                      content: Text(
                        LocaleKeys.server_registration_updated_snackbar_message,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ).tr(args: [state.serverName]),
                    ),
                  );
                }

                context.read<RegistrationHeadersBloc>().add(
                      RegistrationHeadersClear(),
                    );
                Navigator.of(context).pop();
              }
              if (state is RegisterDeviceFailure) {
                if (state.failure == CertificateVerificationFailure()) {
                  await showDialog(
                    context: context,
                    builder: (_) {
                      return BlocProvider.value(
                        value: context.read<RegisterDeviceBloc>(),
                        child: const CertificateFailureDialog(),
                      );
                    },
                  );
                } else {
                  await showDialog(
                    context: context,
                    builder: (context) => RegistrationFailureDialog(
                      failure: state.failure,
                    ),
                  );
                }
              }
            },
            child: Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.only(
                  left: 8,
                  top: 8,
                  right: 8,
                  bottom: kFloatingActionButtonMargin + 48,
                ),
                children: [
                  const ServerRegistrationStepOne(),
                  const Gap(8),
                  ServerRegistrationStepTwo(
                    primaryController: primaryController,
                    secondaryController: secondaryController,
                    tokenController: tokenController,
                  ),
                  const Gap(8),
                  const ServerRegistrationStepThree(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
