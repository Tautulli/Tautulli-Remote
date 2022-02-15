import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/widgets/heading.dart';

class RegistrationInstruction extends StatelessWidget {
  final bool isOptional;
  final String heading;
  final Widget child;

  const RegistrationInstruction({
    Key? key,
    this.isOptional = false,
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Heading(text: heading),
              if (isOptional) const Gap(4),
              if (isOptional)
                Text(
                  '(optional)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.subtitle2!.color,
                  ),
                ),
            ],
          ),
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
