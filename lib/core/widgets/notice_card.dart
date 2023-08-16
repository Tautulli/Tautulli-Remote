import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'card_with_forced_tint.dart';

class NoticeCard extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? content;
  final Color? color;

  const NoticeCard({
    super.key,
    required this.leading,
    required this.title,
    this.content,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CardWithForcedTint(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Center(
                child: leading,
              ),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (content != null) const Gap(4),
                  if (content != null) Text(content!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
