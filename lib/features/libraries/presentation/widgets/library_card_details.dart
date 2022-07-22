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
        if (library.sectionType == SectionType.artist) _artistMediaCount(),
        if (library.sectionType == SectionType.movie) _movieMediaCount(),
        if (library.sectionType == SectionType.photo) _photoMediaCount(),
        if (library.sectionType == SectionType.show) _showMediaCount(),
        if (library.sectionType == SectionType.video) _videoMediaCount(),
        _playsAndDuration(),
      ],
    );
  }

  Widget _artistMediaCount() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: LocaleKeys.artists_title.tr()),
          const TextSpan(
            text: ' ',
          ),
          TextSpan(
            text: library.count.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 13,
              color: Colors.grey[200],
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
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 13,
              color: Colors.grey[200],
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
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 13,
              color: Colors.grey[200],
            ),
          ),
        ],
      ),
    );
  }

  Widget _movieMediaCount() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: LocaleKeys.movies_title.tr()),
          const TextSpan(
            text: ' ',
          ),
          TextSpan(
            text: library.count.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 13,
              color: Colors.grey[200],
            ),
          ),
        ],
      ),
    );
  }

  Widget _photoMediaCount() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: LocaleKeys.albums_title.tr()),
          const TextSpan(
            text: ' ',
          ),
          TextSpan(
            text: library.count.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 13,
              color: Colors.grey[200],
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
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 13,
              color: Colors.grey[200],
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
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 13,
              color: Colors.grey[200],
            ),
          ),
        ],
      ),
    );
  }

  Widget _showMediaCount() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: LocaleKeys.shows_title.tr()),
          const TextSpan(
            text: ' ',
          ),
          TextSpan(
            text: library.count.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 13,
              color: Colors.grey[200],
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
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 13,
              color: Colors.grey[200],
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
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 13,
              color: Colors.grey[200],
            ),
          ),
        ],
      ),
    );
  }

  Widget _videoMediaCount() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: LocaleKeys.videos_title.tr()),
          const TextSpan(
            text: ' ',
          ),
          TextSpan(
            text: library.count.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 13,
              color: Colors.grey[200],
            ),
          ),
        ],
      ),
    );
  }

  Widget _playsAndDuration() {
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
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 13,
                  color: Colors.grey[200],
                ),
              ),
            ],
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
                    if (durationMap['day']! > 1 ||
                        durationMap['hour']! > 1 ||
                        durationMap['min']! > 1 ||
                        durationMap['sec']! > 1)
                      TextSpan(
                        text: '${LocaleKeys.time_title.tr()} ',
                      ),
                    if (durationMap['day']! > 0)
                      TextSpan(
                        children: [
                          TextSpan(
                            text: durationMap['day'].toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                              color: Colors.grey[200],
                            ),
                          ),
                          TextSpan(
                            text: ' days ',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                              color: Colors.grey[200],
                            ),
                          ),
                        ],
                      ),
                    if (durationMap['hour']! > 0)
                      TextSpan(
                        children: [
                          TextSpan(
                            text: durationMap['hour'].toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                              color: Colors.grey[200],
                            ),
                          ),
                          TextSpan(
                            text: ' hrs ',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                              color: Colors.grey[200],
                            ),
                          ),
                        ],
                      ),
                    if (durationMap['min']! > 0)
                      TextSpan(
                        children: [
                          TextSpan(
                            text: durationMap['min'].toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                              color: Colors.grey[200],
                            ),
                          ),
                          TextSpan(
                            text: ' mins',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                              color: Colors.grey[200],
                            ),
                          ),
                        ],
                      ),
                    if (durationMap['day']! < 1 &&
                        durationMap['hour']! < 1 &&
                        durationMap['min']! < 1 &&
                        durationMap['sec']! > 0)
                      TextSpan(
                        children: [
                          TextSpan(
                            text: durationMap['sec'].toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                              color: Colors.grey[200],
                            ),
                          ),
                          TextSpan(
                            text: ' secs',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                              color: Colors.grey[200],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
