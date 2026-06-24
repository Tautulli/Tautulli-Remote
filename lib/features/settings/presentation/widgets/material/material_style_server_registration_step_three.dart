import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../translations/locale_keys.g.dart';
import '../../../data/models/custom_header_model.dart';
import '../../bloc/registration_headers_bloc.dart';
import 'bottom_sheets/material_style_custom_http_header_bottom_sheet.dart';
import 'list_tiles/material_style_custom_header_list_tile.dart';
import 'material_style_registration_instruction.dart';

class MaterialStyleServerRegistrationStepThree extends StatelessWidget {
  const MaterialStyleServerRegistrationStepThree({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationHeadersBloc, RegistrationHeadersState>(
      builder: (context, state) {
        return MaterialStyleRegistrationInstruction(
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
                  onPressed: () async => await showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => MaterialStyleCustomHttpHeaderBottomSheet(
                      forRegistration: true,
                      currentHeaders: state is RegistrationHeadersLoaded
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
                  ),
                ),
              ),
            ],
          ),
          child: state is RegistrationHeadersLoaded && state.headers.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: state.headers
                      .map(
                        (header) => MaterialStyleCustomHeaderListTile(
                          forRegistration: true,
                          title: header.key,
                          subtitle: header.value,
                        ),
                      )
                      .toList(),
                )
              : null,
        );
      },
    );
  }
}
