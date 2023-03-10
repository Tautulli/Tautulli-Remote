import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:quiver/strings.dart';

import '../../../../core/helpers/data_unit_helper.dart';
import '../../../../core/helpers/time_helper.dart';
import '../../../../core/types/media_type.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../data/models/media_model.dart';

class MediaDetailsTabDetails extends StatelessWidget {
  final MediaModel? metadata;

  const MediaDetailsTabDetails({
    super.key,
    required this.metadata,
  });

  @override
  Widget build(BuildContext context) {
    if (metadata != null) {
      return Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
                child: Column(
                  children: [
                    if (isNotBlank(metadata!.studio))
                      _ItemRow(
                        title: LocaleKeys.studio_title.tr(),
                        item: Text(
                          metadata!.studio!,
                        ),
                      ),
                    if (metadata!.originallyAvailableAt != null)
                      _ItemRow(
                        title: [MediaType.photo, MediaType.clip].contains(metadata!.mediaType)
                            ? LocaleKeys.taken_title.tr()
                            : LocaleKeys.aired_title.tr(),
                        item: Text(
                          DateFormat('yMMMMd').format(metadata!.originallyAvailableAt!),
                        ),
                      ),
                    if (metadata!.duration != null)
                      _ItemRow(
                        title: LocaleKeys.runtime_title.tr(),
                        item: Text(
                          TimeHelper.simple(metadata!.duration!),
                        ),
                      ),
                    if (isNotBlank(metadata!.contentRating))
                      _ItemRow(
                        title: LocaleKeys.rated_title.tr(),
                        item: Text(
                          metadata!.contentRating!,
                        ),
                      ),
                    if (metadata!.genres != null && metadata!.genres!.isNotEmpty)
                      _ItemRow(
                        title: LocaleKeys.genres_title.tr(),
                        item: Text(
                          metadata!.genres!.length > 8
                              ? metadata!.genres!.sublist(0, 8).join(', ')
                              : metadata!.genres!.join(', '),
                        ),
                      ),
                    if (metadata!.directors != null && metadata!.directors!.isNotEmpty)
                      _ItemRow(
                        title: LocaleKeys.directed_by_title.tr(),
                        item: Text(
                          metadata!.directors!.length > 8
                              ? metadata!.directors!.sublist(0, 8).join(', ')
                              : metadata!.directors!.join(', '),
                        ),
                      ),
                    if (metadata!.writers != null && metadata!.writers!.isNotEmpty)
                      _ItemRow(
                        title: LocaleKeys.written_by_title.tr(),
                        item: Text(
                          metadata!.writers!.length > 8
                              ? metadata!.writers!.sublist(0, 8).join(', ')
                              : metadata!.writers!.join(', '),
                        ),
                      ),
                    if (metadata!.actors != null && metadata!.actors!.isNotEmpty)
                      _ItemRow(
                        title: LocaleKeys.starring_title.tr(),
                        item: Text(
                          metadata!.actors!.length > 8
                              ? metadata!.actors!.sublist(0, 8).join(', ')
                              : metadata!.actors!.join(', '),
                        ),
                      ),
                    const Gap(16),
                    if (isNotBlank(metadata!.mediaInfo?.container))
                      _ItemRow(
                        title: LocaleKeys.container_title.tr(),
                        item: Text(
                          metadata!.mediaInfo!.container!.toUpperCase(),
                        ),
                      ),
                    if (isNotBlank(metadata!.mediaInfo?.videoFullResolution) &&
                        isNotBlank(metadata!.mediaInfo?.videoCodec))
                      _ItemRow(
                        title: LocaleKeys.video_title.tr(),
                        item: Text(
                          '${metadata!.mediaInfo!.videoResolution!.toUpperCase()} (${metadata!.mediaInfo!.videoCodec!.toUpperCase()})',
                        ),
                      ),
                    if (metadata!.mediaInfo?.audioChannelLayout != null && isNotBlank(metadata!.mediaInfo?.audioCodec))
                      _ItemRow(
                        title: LocaleKeys.audio_title.tr(),
                        item: Text(
                          '${metadata!.mediaInfo!.audioChannelLayout} (${metadata!.mediaInfo!.audioCodec!.toUpperCase()})',
                        ),
                      ),
                    if (metadata!.mediaInfo?.bitrate != null)
                      _ItemRow(
                        title: LocaleKeys.bitrate_title.tr(),
                        item: Text(
                          DataUnitHelper.bitrate(metadata!.mediaInfo!.bitrate!),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return const SizedBox();
  }
}

class _ItemRow extends StatelessWidget {
  final String title;
  final Widget item;

  const _ItemRow({
    required this.title,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.ideographic,
        children: [
          SizedBox(
            width: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 13,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          const Gap(8),
          Expanded(
            child: item,
          ),
        ],
      ),
    );
  }
}
