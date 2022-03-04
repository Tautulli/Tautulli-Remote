import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/custom_header_model.dart';
import '../bloc/registration_headers_bloc.dart';
import 'dialogs/custom_header_type_dialog.dart';
import 'registration_instruction.dart';

class ServerRegistrationStepThree extends StatelessWidget {
  const ServerRegistrationStepThree({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationHeadersBloc, RegistrationHeadersState>(
      builder: (context, state) {
        return RegistrationInstruction(
          isOptional: true,
          hasChildPadding: false,
          heading: 'Step 3',
          child: state is RegistrationHeadersLoaded && state.headers.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: state.headers,
                )
              : null,
          action: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  child: const Text('Add Custom Header'),
                  onPressed: () async => await showDialog(
                    context: context,
                    builder: (_) {
                      return CustomHeaderTypeDialog(
                        forRegistration: true,
                        currentHeaders: state is RegistrationHeadersLoaded
                            ? state.headers
                                .map(
                                  (widget) => CustomHeaderModel(
                                    key: widget.title,
                                    value: widget.subtitle,
                                  ),
                                )
                                .toList()
                            : [],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
