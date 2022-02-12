import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/registration_headers_bloc.dart';

class RegistrationExitDialog extends StatelessWidget {
  const RegistrationExitDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Are you sure you want to exit?'),
      content:
          const Text('Any currently entered information will be discarded.'),
      actions: [
        TextButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: const Text('DISCARD'),
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).errorColor,
          ),
          onPressed: () {
            context.read<RegistrationHeadersBloc>().add(
                  RegistrationHeadersClear(),
                );
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
