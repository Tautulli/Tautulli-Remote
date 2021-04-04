import 'package:flutter/material.dart';

import '../error/failure.dart';

class ErrorMessage extends StatelessWidget {
  final Failure failure;
  final String message;
  final String suggestion;

  const ErrorMessage({
    Key key,
    @required this.failure,
    @required this.message,
    this.suggestion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (failure != SettingsFailure())
            const Text(
              'ERROR',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          const SizedBox(
            height: 5,
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            suggestion,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
