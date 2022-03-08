import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
    Key? key,
    this.isOptional = false,
    this.hasChildPadding = true,
    required this.heading,
    this.child,
    this.action,
    this.actionOnTop = false,
  }) : super(key: key);

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
                  '(${LocaleKeys.optional})',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.subtitle2!.color,
                  ),
                ).tr(),
            ],
          ),
        ),
        if (action != null && actionOnTop) action!,
        if (child != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).dialogTheme.backgroundColor,
              ),
              child: Padding(
                padding: EdgeInsets.all(hasChildPadding ? 8.0 : 0),
                child: child,
              ),
            ),
          ),
        if (action != null && !actionOnTop) action!
      ],
    );
  }
}
