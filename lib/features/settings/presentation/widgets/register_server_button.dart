import 'package:flutter/material.dart';

import '../pages/server_registration_page.dart';

class RegisterServerButton extends StatelessWidget {
  const RegisterServerButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Register a Tautulli Server'),
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) {
              return const ServerRegistrationPage();
            },
          ),
        );
      },
    );
  }
}
