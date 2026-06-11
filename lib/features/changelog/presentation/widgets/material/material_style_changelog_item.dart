import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/widgets/material/material_style_card.dart';
import 'material_style_change_type_tag.dart';

class MaterialStyleChangelogItem extends StatelessWidget {
  final Map release;
  final bool bottomPadding;

  const MaterialStyleChangelogItem(
    this.release, {
    super.key,
    this.bottomPadding = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding ? 8 : 0),
      child: MaterialStyleCard(
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
              const Divider(),
              if (release['intro'] != null)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(release['intro']),
                    const Divider(),
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
                            MaterialStyleChangeTypeTag(change['type']),
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
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
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
