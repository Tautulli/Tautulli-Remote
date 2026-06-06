import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

import 'cupertino_card.dart';

class CupertinoNoticeCard extends StatelessWidget {
  final Widget leading;
  final String title;

  const CupertinoNoticeCard({
    super.key,
    required this.leading,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoCard(
      child: Padding(
        padding: const EdgeInsets.all(8),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
