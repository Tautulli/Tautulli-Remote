import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:quiver/strings.dart';

class CupertinoStyleStatusPage extends StatelessWidget {
  final String message;
  final String? suggestion;
  final Widget? action;

  const CupertinoStyleStatusPage({
    super.key,
    required this.message,
    this.suggestion,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
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
                  if (action != null) const Gap(16),
                  if (action != null) action!,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
