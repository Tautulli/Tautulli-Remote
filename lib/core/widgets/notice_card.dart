import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NoticeCard extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? content;
  final Color? color;

  const NoticeCard({
    Key? key,
    required this.leading,
    required this.title,
    this.content,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? Theme.of(context).cardTheme.color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: leading,
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
