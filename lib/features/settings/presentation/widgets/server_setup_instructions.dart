import 'package:flutter/material.dart';

import '../../../../core/widgets/text_list.dart';

class ServerSetupInstructions extends StatelessWidget {
  final bool showWarning;
  final double fontSize;

  const ServerSetupInstructions({
    Key key,
    this.showWarning = true,
    this.fontSize = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (showWarning)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              'This app is not registered to a Tautulli server.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
          ),
        Text(
          'To register with a Tautulli server:',
          style: TextStyle(fontSize: fontSize),
        ),
        const SizedBox(height: 4),
        const TextList(
          numberedList: true,
          textItems: [
            'Open the Tautulli web interface on another device.',
            'Navigate to Settings > Tautulli Remote App.',
            'Select "Register a new device".',
            'Use the button below to register with the server.'
          ],
          fontSize: 16,
        ),
      ],
    );
  }
}
