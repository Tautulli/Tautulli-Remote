import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:quiver/strings.dart';

import '../../../../../core/widgets/cupertino/cupertino_style_card.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../data/models/media_model.dart';

class CupertinoStyleMediaDetailsTabSummary extends StatelessWidget {
  final MediaModel? metadata;

  const CupertinoStyleMediaDetailsTabSummary({
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

          return CupertinoStyleCard(
            horizontalPadding: 8,
            child: GestureDetector(
              onTap: tp.didExceedMaxLines
                  ? () async {
                      return await showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          content: Column(
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
                          actions: [
                            CupertinoDialogAction(
                              isDefaultAction: true,
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text(LocaleKeys.close_title).tr(),
                            ),
                          ],
                        ),
                      );
                    }
                  : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
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
