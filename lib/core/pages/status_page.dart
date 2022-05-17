import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:quiver/strings.dart';

class StatusPage extends StatelessWidget {
  final String message;
  final String? suggestion;
  final Widget? action;
  final bool scrollable;

  const StatusPage({
    super.key,
    required this.message,
    this.suggestion,
    this.action,
    this.scrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: scrollable
              ? const AlwaysScrollableScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              minWidth: constraints.maxWidth,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (isNotBlank(suggestion)) const Gap(8),
                    if (isNotBlank(suggestion))
                      Text(
                        suggestion!,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    if (action != null) const Gap(4),
                    if (action != null) action!,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
