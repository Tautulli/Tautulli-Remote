import 'package:flutter/material.dart';

import '../../../../core/widgets/heading.dart';

class RegistrationInstruction extends StatelessWidget {
  final String heading;
  final Widget child;

  const RegistrationInstruction({
    Key? key,
    required this.heading,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Heading(text: heading),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).dialogTheme.backgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}
