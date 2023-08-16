import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../translations/locale_keys.g.dart';

class ActiveConnectionIndicator extends StatelessWidget {
  const ActiveConnectionIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 35,
        height: 35,
        color: Colors.transparent,
        child: Center(
          child: FaIcon(
            FontAwesomeIcons.solidCircle,
            color: Theme.of(context).colorScheme.primary,
            size: 12,
          ),
        ),
      ),
      onTap: () async => await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(LocaleKeys.active_connection_title).tr(),
          content: const Text(LocaleKeys.active_connection_content).tr(),
          actions: [
            TextButton(
              child: const Text(LocaleKeys.close_title).tr(),
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
