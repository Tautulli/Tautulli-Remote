import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/helpers/time_helper.dart';
import '../../../../core/types/section_type.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../data/models/library_table_model.dart';

class LibraryCardDetails extends StatelessWidget {
  final LibraryTableModel library;

  const LibraryCardDetails({
    super.key,
    required this.library,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          library.sectionName ?? 'Unknown',
          style: const TextStyle(
            fontSize: 17,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        if (library.sectionType == SectionType.artist) _artistMediaCount(context),
        if (library.sectionType == SectionType.movie) _movieMediaCount(context),
        if (library.sectionType == SectionType.photo) _photoMediaCount(context),
        if (library.sectionType == SectionType.show) _showMediaCount(context),
        if (library.sectionType == SectionType.video) _videoMediaCount(context),
        if (library.sectionType != SectionType.photo) _playsAndDuration(context),
      ],
    );
  }

  Widget _artistMediaCount(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: LocaleKeys.artists_title.tr()),
          const TextSpan(
            text: ' ',
          ),
          TextSpan(
            text: library.count.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 13,
            ),
          ),
          const TextSpan(
            text: ' ',
          ),
          TextSpan(text: LocaleKeys.albums_title.tr()),
          const TextSpan(
            text: ' ',
          ),
          TextSpan(
            text: library.parentCount.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 13,
            ),
          ),
          const TextSpan(
            text: ' ',
          ),
          TextSpan(text: LocaleKeys.tracks_title.tr()),
          const TextSpan(
            text: ' ',
          ),
          TextSpan(
            text: library.childCount.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 13,
            ),
          ),
        ],
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _movieMediaCount(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: LocaleKeys.movies_title.tr()),
          const TextSpan(
            text: ' ',
          ),
          TextSpan(
            text: library.count.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 13,
            ),
          ),
        ],
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _photoMediaCount(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: LocaleKeys.albums_title.tr()),
          const TextSpan(
            text: ' ',
          ),
          TextSpan(
            text: library.count.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 13,
            ),
          ),
          const TextSpan(
            text: ' ',
          ),
          TextSpan(text: LocaleKeys.photos_title.tr()),
          const TextSpan(
            text: ' ',
          ),
          TextSpan(
            text: library.parentCount.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 13,
            ),
          ),
          const TextSpan(
            text: ' ',
          ),
          TextSpan(text: LocaleKeys.videos_title.tr()),
          const TextSpan(
            text: ' ',
          ),
          TextSpan(
            text: library.childCount.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 13,
            ),
          ),
        ],
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _showMediaCount(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: LocaleKeys.shows_title.tr()),
          const TextSpan(
            text: ' ',
          ),
          TextSpan(
            text: library.count.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 13,
            ),
          ),
          const TextSpan(
            text: ' ',
          ),
          TextSpan(text: LocaleKeys.seasons_title.tr()),
          const TextSpan(
            text: ' ',
          ),
          TextSpan(
            text: library.parentCount.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 13,
            ),
          ),
          const TextSpan(
            text: ' ',
          ),
          TextSpan(text: LocaleKeys.episodes_title.tr()),
          const TextSpan(
            text: ' ',
          ),
          TextSpan(
            text: library.childCount.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 13,
            ),
          ),
        ],
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _videoMediaCount(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: LocaleKeys.videos_title.tr()),
          const TextSpan(
            text: ' ',
          ),
          TextSpan(
            text: library.count.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 13,
            ),
          ),
        ],
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _playsAndDuration(BuildContext context) {
    Map<String, int> durationMap = TimeHelper.durationMap(
      Duration(seconds: library.duration?.inSeconds ?? 0),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: LocaleKeys.plays_title.tr(),
              ),
              const TextSpan(
                text: ' ',
              ),
              TextSpan(
                text: library.plays.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 13,
                ),
              ),
            ],
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        const Gap(6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  children: [
                    if (durationMap['day']! > 1 || durationMap['hour']! > 1 || durationMap['min']! > 1 || durationMap['sec']! > 1)
                      TextSpan(
                        text: '${LocaleKeys.time_title.tr()} ',
                      ),
                    if (durationMap['day']! > 0)
                      TextSpan(
                        children: [
                          TextSpan(
                            text: durationMap['day'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                            ),
                          ),
                          TextSpan(
                            text: ' ${LocaleKeys.days.tr()} ',
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    if (durationMap['hour']! > 0)
                      TextSpan(
                        children: [
                          TextSpan(
                            text: durationMap['hour'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                            ),
                          ),
                          TextSpan(
                            text: ' ${LocaleKeys.hrs.tr()} ',
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                              // color: Colors.grey[200],
                            ),
                          ),
                        ],
                      ),
                    if (durationMap['min']! > 0)
                      TextSpan(
                        children: [
                          TextSpan(
                            text: durationMap['min'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                            ),
                          ),
                          TextSpan(
                            text: ' ${LocaleKeys.mins.tr()}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    if (durationMap['day']! < 1 && durationMap['hour']! < 1 && durationMap['min']! < 1 && durationMap['sec']! > 0)
                      TextSpan(
                        children: [
                          TextSpan(
                            text: durationMap['sec'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                            ),
                          ),
                          TextSpan(
                            text: ' ${LocaleKeys.secs.tr()}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                  ],
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
