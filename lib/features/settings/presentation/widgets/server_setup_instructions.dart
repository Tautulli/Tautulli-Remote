import 'package:flutter/material.dart';

import '../../../../core/widgets/bullet_item.dart';

class ServerSetupInstructions extends StatelessWidget {
  final bool showWarning;
  final double fontSize;

  const ServerSetupInstructions({
    Key key,
    this.showWarning = true,
    this.fontSize = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (showWarning)
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'This app is not registered to a Tautulli server.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        Text(
          'To register with a Tautulli server:',
          style: TextStyle(fontSize: fontSize),
        ),
        const SizedBox(height: 4),
        BulletItem(
          'Open the Tautulli web interface on another device',
          fontSize: fontSize,
        ),
        const SizedBox(height: 4),
        BulletItem(
          'Navigate to Settings > Tautulli Remote App',
          fontSize: fontSize,
        ),
        const SizedBox(height: 4),
        BulletItem(
          'Select \'Register a new device\'',
          fontSize: fontSize,
        ),
        const SizedBox(height: 4),
        BulletItem(
          'Use the button below to register with the server',
          fontSize: fontSize,
        ),
      ],
    );
  }
}
