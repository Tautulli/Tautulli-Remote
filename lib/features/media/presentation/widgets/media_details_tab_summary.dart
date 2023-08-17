import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:quiver/strings.dart';

import '../../../../core/widgets/card_with_forced_tint.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../data/models/media_model.dart';

class MediaDetailsTabSummary extends StatelessWidget {
  final MediaModel? metadata;

  const MediaDetailsTabSummary({
    super.key,
    required this.metadata,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tp = TextPainter(
            text: TextSpan(text: metadata!.summary!),
            maxLines: 5,
            textDirection: Directionality.of(context),
          );
          tp.layout(maxWidth: constraints.maxWidth);

          return CardWithForcedTint(
            child: InkWell(
              onTap: tp.didExceedMaxLines
                  ? () async {
                      return await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                          content: SizedBox(
                            width: double.maxFinite,
                            child: ListView(
                              children: [
                                if (isNotBlank(metadata?.tagline))
                                  Text(
                                    metadata!.tagline!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                if (isNotBlank(metadata?.tagline)) const Gap(4),
                                Text(metadata!.summary!),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Theme.of(context).colorScheme.onSurface,
                              ),
                              child: const Text(LocaleKeys.close_title).tr(),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    }
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isNotBlank(metadata?.tagline))
                      Text(
                        metadata!.tagline!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (isNotBlank(metadata?.tagline)) const Gap(4),
                    if (metadata?.summary != null)
                      Builder(
                        builder: (context) {
                          if (tp.didExceedMaxLines) {
                            return Text(
                              metadata!.summary!,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            );
                          }

                          return Text(metadata!.summary!);
                        },
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
