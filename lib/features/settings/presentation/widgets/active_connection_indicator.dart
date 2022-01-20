import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ActiveConnectionIndicator extends StatelessWidget {
  const ActiveConnectionIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: FaIcon(
        FontAwesomeIcons.solidCircle,
        color: Theme.of(context).colorScheme.secondary,
        size: 12,
      ),
      onTap: () async => await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Active Connection'),
          content: const Text(
            'This is the current connection address being used by Tautulli Remote.',
          ),
          actions: [
            TextButton(
              child: const Text('CLOSE'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
