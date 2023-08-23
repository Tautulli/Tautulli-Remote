import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../translations/locale_keys.g.dart';
import '../../data/models/custom_header_model.dart';
import '../bloc/registration_headers_bloc.dart';
import 'dialogs/custom_header_type_dialog.dart';
import 'registration_instruction.dart';

class ServerRegistrationStepThree extends StatelessWidget {
  const ServerRegistrationStepThree({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationHeadersBloc, RegistrationHeadersState>(
      builder: (context, state) {
        return RegistrationInstruction(
          isOptional: true,
          hasChildPadding: false,
          heading: '${LocaleKeys.step_title.tr()} 3',
          action: Column(
            children: [
              const Gap(8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  child: const Text(LocaleKeys.add_custom_http_header_title).tr(),
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
          child: state is RegistrationHeadersLoaded && state.headers.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: state.headers,
                )
              : null,
        );
      },
    );
  }
}
