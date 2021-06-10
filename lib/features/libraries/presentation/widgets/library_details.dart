import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/helpers/time_format_helper.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../domain/entities/library.dart';

class LibraryDetails extends StatelessWidget {
  final Library library;

  const LibraryDetails({
    Key key,
    @required this.library,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          library.sectionName,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        _libraryCount(),
        _playsAndDuration(),
      ],
    );
  }

  RichText _libraryCount() {
    String title = '';
    String count = '';
    String parentTitle = '';
    String parentCount = '';
    String childTitle = '';
    String childCount = '';

    switch (library.sectionType) {
      case ('movie'):
        title = '${LocaleKeys.libraries_details_movies.tr()} ';
        count = library.count.toString();
        break;
      case ('show'):
        title = '${LocaleKeys.libraries_details_shows.tr()} ';
        count = library.count.toString();
        parentTitle = '${LocaleKeys.libraries_details_seasons.tr()} ';
        parentCount = library.parentCount.toString();
        childTitle = '${LocaleKeys.libraries_details_episodes.tr()} ';
        childCount = library.childCount.toString();
        break;
      case ('artist'):
        title = '${LocaleKeys.libraries_details_artists.tr()} ';
        count = library.count.toString();
        parentTitle = '${LocaleKeys.libraries_details_albums.tr()} ';
        parentCount = library.parentCount.toString();
        childTitle = '${LocaleKeys.libraries_details_tracks.tr()} ';
        childCount = library.childCount.toString();
        break;
      case ('photo'):
        title = '${LocaleKeys.libraries_details_albums.tr()} ';
        count = library.count.toString();
        parentTitle = '${LocaleKeys.libraries_details_photos.tr()} ';
        parentCount = library.parentCount.toString();
        childTitle = '${LocaleKeys.libraries_details_videos.tr()} ';
        childCount = library.childCount.toString();
    }
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
          ),
          TextSpan(
            text: count,
            style: const TextStyle(
              color: PlexColorPalette.gamboge,
            ),
          ),
          const TextSpan(text: '   '),
          TextSpan(
            text: parentTitle,
          ),
          TextSpan(
            text: parentCount,
            style: const TextStyle(
              color: PlexColorPalette.gamboge,
            ),
          ),
          const TextSpan(text: '   '),
          TextSpan(
            text: childTitle,
          ),
          TextSpan(
            text: childCount,
            style: const TextStyle(
              color: PlexColorPalette.gamboge,
            ),
          ),
        ],
      ),
    );
  }

  RichText _playsAndDuration() {
    Map<String, int> durationMap =
        TimeFormatHelper.durationMap(Duration(seconds: library.duration));

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${LocaleKeys.libraries_details_plays.tr()} ',
          ),
          TextSpan(
            text: library.plays.toString(),
            style: const TextStyle(
              color: PlexColorPalette.gamboge,
            ),
          ),
          const TextSpan(text: '   '),
          if (durationMap['day'] > 1 ||
              durationMap['hour'] > 1 ||
              durationMap['min'] > 1 ||
              durationMap['sec'] > 1)
            TextSpan(
              text: '${LocaleKeys.general_details_duration.tr()} ',
            ),
          if (durationMap['day'] > 0)
            TextSpan(
              children: [
                TextSpan(
                  text: durationMap['day'].toString(),
                  style: const TextStyle(
                    color: PlexColorPalette.gamboge,
                  ),
                ),
                TextSpan(
                  text: ' ${LocaleKeys.general_details_days.tr()} ',
                ),
              ],
            ),
          if (durationMap['hour'] > 0)
            TextSpan(
              children: [
                TextSpan(
                  text: durationMap['hour'].toString(),
                  style: const TextStyle(
                    color: PlexColorPalette.gamboge,
                  ),
                ),
                TextSpan(
                  text: ' ${LocaleKeys.general_details_hrs.tr()} ',
                ),
              ],
            ),
          if (durationMap['min'] > 0)
            TextSpan(
              children: [
                TextSpan(
                  text: durationMap['min'].toString(),
                  style: const TextStyle(
                    color: PlexColorPalette.gamboge,
                  ),
                ),
                TextSpan(
                  text: ' ${LocaleKeys.general_details_mins.tr()}',
                ),
              ],
            ),
          if (durationMap['day'] < 1 &&
              durationMap['hour'] < 1 &&
              durationMap['min'] < 1 &&
              durationMap['sec'] > 0)
            TextSpan(
              children: [
                TextSpan(
                  text: durationMap['sec'].toString(),
                  style: const TextStyle(
                    color: PlexColorPalette.gamboge,
                  ),
                ),
                TextSpan(
                  text: ' ${LocaleKeys.general_details_secs.tr()}',
                ),
              ],
            ),
        ],
      ),
    );
  }
}
