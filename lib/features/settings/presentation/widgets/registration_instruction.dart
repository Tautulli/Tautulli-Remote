import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/widgets/card_with_forced_tint.dart';
import '../../../../core/widgets/heading.dart';
import '../../../../translations/locale_keys.g.dart';

class RegistrationInstruction extends StatelessWidget {
  final bool isOptional;
  final bool hasChildPadding;
  final String heading;
  final Widget? child;
  final Widget? action;
  final bool actionOnTop;

  const RegistrationInstruction({
    super.key,
    this.isOptional = false,
    this.hasChildPadding = true,
    required this.heading,
    this.child,
    this.action,
    this.actionOnTop = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 8,
            bottom: !actionOnTop && child != null ? 8 : 0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Heading(text: heading),
              if (isOptional) const Gap(4),
              if (isOptional)
                Text(
                  '(${LocaleKeys.optional.tr()})',
                  style: const TextStyle(fontSize: 12),
                ),
            ],
          ),
        ),
        if (action != null && actionOnTop) action!,
        if (child != null)
          CardWithForcedTint(
            child: Padding(
              padding: EdgeInsets.all(hasChildPadding ? 8.0 : 0),
              child: child,
            ),
          ),
        if (action != null && !actionOnTop) action!
      ],
    );
  }
}
