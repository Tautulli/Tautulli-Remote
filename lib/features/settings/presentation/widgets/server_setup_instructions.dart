import 'package:flutter/material.dart';

import '../../../../core/widgets/bullet_item.dart';

class ServerSetupInstructions extends StatelessWidget {
  final bool showWarning;

  const ServerSetupInstructions({
    Key key,
    this.showWarning = true,
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
        const Text('To register with a Tautulli server:'),
        const BulletItem('Open the Tautulli web interface on another device'),
        const BulletItem('Navigate to Settings > Tautulli Remote App'),
        const BulletItem('Select \'Register a new device\''),
        const BulletItem('Use the below option to register with a new server'),
      ],
    );
  }
}
