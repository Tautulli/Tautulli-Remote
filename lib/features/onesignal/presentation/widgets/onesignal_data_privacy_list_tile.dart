import 'package:flutter/material.dart';

class OneSignalDataPrivacyListTile extends StatelessWidget {
  const OneSignalDataPrivacyListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SwitchListTile(
        title: const Text('Consent to OneSignal data privacy'),
        subtitle: RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Status: ',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
              TextSpan(
                text: 'Not Accepted X',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Theme.of(context).errorColor,
                ),
              ),
            ],
          ),
        ),
        value: false,
        onChanged: (value) {},
      ),
    );
  }
}
