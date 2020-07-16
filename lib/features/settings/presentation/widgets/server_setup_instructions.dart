import 'package:flutter/material.dart';

class ServerSetupInstructions extends StatelessWidget {
  const ServerSetupInstructions({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            'This app is not registered to a Tautulli server.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Text('To register this app do the following:'),
        BulletItem('Open the Tautulli web interface on another device'),
        BulletItem('Navigate to Settings > Tautulli Remote App'),
        BulletItem('Select \'Register a new device\''),
        BulletItem('Use the button below to scan the QR code'),
      ],
    );
  }
}

class BulletItem extends StatelessWidget {
  final String text;

  const BulletItem(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
      ),
      child: Text('• $text'),
    );
  }
}
