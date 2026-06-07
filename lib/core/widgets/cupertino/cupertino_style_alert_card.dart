import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

import 'cupertino_style_card.dart';

class CupertinoStyleAlertCard extends StatelessWidget {
  final Color? tint;
  final Widget? leading;
  final String? title;
  final String? content;
  final List<Widget>? actions;

  const CupertinoStyleAlertCard({
    super.key,
    this.tint,
    this.leading,
    this.title,
    this.content,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoStyleCard(
      tint: tint ?? CupertinoColors.systemRed.highContrastColor,
      horizontalPadding: 20,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: Column(
          children: [
            Row(
              children: [
                if (leading != null) leading!,
                if (leading != null) const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null)
                        Text(
                          title!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (title != null && content != null) const Gap(8),
                      if (content != null) Text(content!),
                    ],
                  ),
                ),
              ],
            ),
            if (actions != null && actions!.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!,
              ),
          ],
        ),
      ),
    );
  }
}
