import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/widgets/material/material_style_page_body.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../data/models/custom_header_model.dart';
import '../../bloc/register_device_bloc.dart';
import '../../bloc/registration_headers_bloc.dart';
import '../../bloc/settings_bloc.dart';
import '../../widgets/material/dialogs/material_style_certificate_failure_dialog.dart';
import '../../widgets/material/dialogs/material_style_registration_exit_dialog.dart';
import '../../widgets/material/dialogs/material_style_registration_failure_dialog.dart';
import '../../widgets/material/material_style_server_registration_step_one.dart';
import '../../widgets/material/material_style_server_registration_step_three.dart';
import '../../widgets/material/material_style_server_registration_step_two.dart';

class MaterialStyleServerRegistrationPage extends StatelessWidget {
  const MaterialStyleServerRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<RegisterDeviceBloc>(),
      child: const MaterialStyleServerRegistrationView(),
    );
  }
}

class MaterialStyleServerRegistrationView extends StatefulWidget {
  const MaterialStyleServerRegistrationView({super.key});

  @override
  State<MaterialStyleServerRegistrationView> createState() => _MaterialStyleServerRegistrationViewState();
}

class _MaterialStyleServerRegistrationViewState extends State<MaterialStyleServerRegistrationView> {
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
                    settingsBloc: context.read<SettingsBloc>(),
                  ),
                );
              }
            },
          );
        },
      ),
      body: MaterialStylePageBody(
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;

            final NavigatorState navigator = Navigator.of(context);
            final bool? shouldPop = await showDialog(
              context: context,
              builder: (_) {
                return const MaterialStyleRegistrationExitDialog();
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
                        child: const MaterialStyleCertificateFailureDialog(),
                      );
                    },
                  );
                } else {
                  await showDialog(
                    context: context,
                    builder: (context) => MaterialStyleRegistrationFailureDialog(
                      failure: state.failure,
                    ),
                  );
                }
              }
            },
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.only(
                  left: 8,
                  top: 8,
                  right: 8,
                  bottom: kFloatingActionButtonMargin + 48,
                ),
                children: [
                  const MaterialStyleServerRegistrationStepOne(),
                  const Gap(8),
                  MaterialStyleServerRegistrationStepTwo(
                    primaryController: _primaryController,
                    secondaryController: _secondaryController,
                    tokenController: _tokenController,
                  ),
                  const Gap(8),
                  const MaterialStyleServerRegistrationStepThree(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
