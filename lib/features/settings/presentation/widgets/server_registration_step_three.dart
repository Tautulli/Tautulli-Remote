import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/bullet_list.dart';
import '../bloc/registration_headers_bloc.dart';
import 'custom_header_type_dialog.dart';
import 'registration_instruction.dart';

class ServerRegistrationStepThree extends StatelessWidget {
  const ServerRegistrationStepThree({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RegistrationInstruction(
      heading: 'Step 3',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BulletList(
            listItems: ['Add any customer headers needed.'],
          ),
          BlocBuilder<RegistrationHeadersBloc, RegistrationHeadersState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    state is RegistrationHeadersLoaded ? state.headers : [],
              );
            },
          ),
          // const CustomHeaderListTile(
          //   title: 'Authorization',
          //   subtitle: 'Value',
          //   showLeading: false,
          // ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  child: const Text('Add Custom Header'),
                  onPressed: () async => await showDialog(
                    context: context,
                    builder: (_) {
                      return BlocProvider.value(
                        value: context.read<RegistrationHeadersBloc>(),
                        child: const CustomHeaderTypeDialog(),
                      );
                      // return const CustomHeaderTypeDialog();
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
