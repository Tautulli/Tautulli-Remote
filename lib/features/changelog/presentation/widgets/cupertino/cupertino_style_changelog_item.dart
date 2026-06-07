import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/widgets/ios/cupertino_card.dart';
import 'cupertino_style_change_type_tag.dart';

class CupertinoStyleChangelogItem extends StatelessWidget {
  final Map release;
  final bool bottomPadding;

  const CupertinoStyleChangelogItem(
    this.release, {
    super.key,
    this.bottomPadding = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding ? 8 : 0),
      child: CupertinoCard(
        horizontalPadding: 8,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    release['version'],
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    release['date'],
                    style: const TextStyle(fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              const Divider(
                color: CupertinoColors.separator,
              ),
              if (release['intro'] != null)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(release['intro']),
                    const Divider(
                      color: CupertinoColors.separator,
                    ),
                  ],
                ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: release['changes']
                    .map<Widget>(
                      (change) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CupertinoStyleChangeTypeTag(change['type']),
                            const Gap(8),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(change['detail']),
                                  if (change['additional'] != null)
                                    Text(
                                      change['additional'],
                                      style: const TextStyle(
                                        color: CupertinoColors.inactiveGray,
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
