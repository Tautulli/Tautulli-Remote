import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../dependency_injection.dart' as di;
import '../bloc/register_device_bloc.dart';
import '../bloc/registration_headers_bloc.dart';
import '../widgets/dialogs/certificate_failure_dialog.dart';
import '../widgets/dialogs/registration_exit_dialog.dart';
import '../widgets/dialogs/registration_failure_dialog.dart';
import '../widgets/server_registration_step_four.dart';
import '../widgets/server_registration_step_one.dart';
import '../widgets/server_registration_step_three.dart';
import '../widgets/server_registration_step_two.dart';

class ServerRegistrationPage extends StatelessWidget {
  const ServerRegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<RegisterDeviceBloc>(),
      child: const ServerRegistrationView(),
    );
  }
}

class ServerRegistrationView extends StatelessWidget {
  const ServerRegistrationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _primaryController = TextEditingController();
    final _secondaryController = TextEditingController();
    final _tokenController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Server Registration'),
      ),
      body: PageBody(
        child: WillPopScope(
          onWillPop: () async => await showDialog(
            context: context,
            builder: (_) {
              return const RegistrationExitDialog();
            },
          ),
          child: BlocListener<RegisterDeviceBloc, RegisterDeviceState>(
            listener: (context, state) async {
              if (state is RegisterDeviceSuccess) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green[700],
                    content: Text('Updated ${state.serverName} registration'),
                  ),
                );

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
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  const ServerRegistrationStepOne(),
                  const Gap(8),
                  ServerRegistrationStepTwo(
                    primaryController: _primaryController,
                    secondaryController: _secondaryController,
                    tokenController: _tokenController,
                  ),
                  const Gap(8),
                  const ServerRegistrationStepThree(),
                  const Gap(8),
                  ServerRegistrationStepFour(
                    formKey: _formKey,
                    primaryController: _primaryController,
                    secondaryController: _secondaryController,
                    tokenController: _tokenController,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
