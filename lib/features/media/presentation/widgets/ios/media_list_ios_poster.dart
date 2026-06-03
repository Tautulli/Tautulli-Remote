import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/types/media_type.dart';
import '../../../../../core/widgets/ios/ios_poster.dart';

class MediaListIosPoster extends StatelessWidget {
  final String? title;
  final int? year;
  final int? ratingKey;
  final MediaType? mediaType;
  final Uri? posterUri;
  final Function()? onTap;

  const MediaListIosPoster({
    super.key,
    this.title,
    this.year,
    this.ratingKey,
    required this.mediaType,
    this.posterUri,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: ClipRSuperellipse(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: IosPoster(
                      mediaType: mediaType,
                      uri: Uri.tryParse(posterUri.toString()),
                    ),
                  ),
                  if (mediaType == MediaType.photoAlbum)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Stack(
                          children: [
                            Container(
                              width: 25,
                              height: 25,
                              color: CupertinoColors.black.withValues(alpha: 0.60),
                            ),
                            Positioned.fill(
                              child: Center(
                                child: Opacity(
                                  opacity: 0.8,
                                  child: Icon(
                                    CupertinoIcons.folder_fill,
                                    size: 16,
                                    color: ThemeHelper.cupertinoCardIconColor(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (mediaType == MediaType.clip)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Stack(
                          children: [
                            Container(
                              width: 25,
                              height: 25,
                              color: CupertinoColors.black.withValues(alpha: 0.60),
                            ),
                            Positioned.fill(
                              child: Center(
                                child: Opacity(
                                  opacity: 0.8,
                                  child: Icon(
                                    CupertinoIcons.videocam_fill,
                                    size: 16,
                                    color: ThemeHelper.cupertinoCardIconColor(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 26,
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Column(
            children: [
              const Gap(4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
