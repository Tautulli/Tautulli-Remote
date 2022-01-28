import 'package:flutter/material.dart';

import '../bloc/logging_bloc.dart';

class ClearLoggingDialog extends StatelessWidget {
  final LoggingBloc loggingBloc;

  const ClearLoggingDialog(
    this.loggingBloc, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
          'Are you sure you want to clear the Tautulli Remote logs?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            loggingBloc.add(LoggingClear());
            Navigator.of(context).pop();
          },
          child: const Text('CONFIRM'),
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
          ),
        ),
      ],
    );
  }
}
