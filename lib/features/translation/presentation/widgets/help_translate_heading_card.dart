import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HelpTranslateHeadingCard extends StatelessWidget {
  const HelpTranslateHeadingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Thank you for helping to translate Tautulli Remote!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gap(8),
                Text(
                  'Your contributions help improve Tautulli Remote and make it accessible to more of the community.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const Gap(4),
        const Divider(
          indent: 32,
          endIndent: 32,
        ),
        const Gap(4),
      ],
    );
  }
}
