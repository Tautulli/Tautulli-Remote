import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/widgets/bullet_list.dart';
import '../../data/models/custom_header_model.dart';
import '../bloc/register_device_bloc.dart';
import '../bloc/registration_headers_bloc.dart';
import '../bloc/settings_bloc.dart';
import 'registration_instruction.dart';

class ServerRegistrationStepFour extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController primaryController;
  final TextEditingController secondaryController;
  final TextEditingController tokenController;

  const ServerRegistrationStepFour({
    Key? key,
    required this.formKey,
    required this.primaryController,
    required this.secondaryController,
    required this.tokenController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationHeadersBloc, RegistrationHeadersState>(
      builder: (context, state) {
        return RegistrationInstruction(
          heading: 'Step 4',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BulletList(
                listItems: ['Register your Tautulli server.'],
              ),
              const Gap(8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: const Text('Register Server'),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<RegisterDeviceBloc>().add(
                                RegisterDeviceStarted(
                                  primaryConnectionAddress:
                                      primaryController.text,
                                  secondaryConnectionAddress:
                                      secondaryController.text,
                                  deviceToken: tokenController.text,
                                  headers: state is RegistrationHeadersLoaded
                                      ? state.headers
                                          .map(
                                            (widget) => CustomHeaderModel(
                                                key: widget.title,
                                                value: widget.subtitle),
                                          )
                                          .toList()
                                      : [],
                                  settingsBloc: context.read<SettingsBloc>(),
                                ),
                              );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
