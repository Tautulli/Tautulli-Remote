import 'package:flutter/material.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/helpers/time_format_helper.dart';
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
          style: TextStyle(
            fontSize: 18,
            color: TautulliColorPalette.not_white,
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
        title = 'MOVIES ';
        count = library.count.toString();
        break;
      case ('show'):
        title = 'SHOWS ';
        count = library.count.toString();
        parentTitle = 'SEASONS ';
        parentCount = library.parentCount.toString();
        childTitle = 'EPISODES ';
        childCount = library.childCount.toString();
        break;
      case ('artist'):
        title = 'ARTISTS ';
        count = library.count.toString();
        parentTitle = 'ALBUMS ';
        parentCount = library.parentCount.toString();
        childTitle = 'TRACKS ';
        childCount = library.childCount.toString();
        break;
      case ('photo'):
        title = 'ALBUMS ';
        count = library.count.toString();
        parentTitle = 'PHOTOS ';
        parentCount = library.parentCount.toString();
        childTitle = 'VIDEOS ';
        childCount = library.childCount.toString();
    }
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: TextStyle(
              color: TautulliColorPalette.not_white,
            ),
          ),
          TextSpan(
            text: count,
            style: TextStyle(
              color: PlexColorPalette.gamboge,
            ),
          ),
          TextSpan(text: '   '),
          TextSpan(
            text: parentTitle,
            style: TextStyle(
              color: TautulliColorPalette.not_white,
            ),
          ),
          TextSpan(
            text: parentCount,
            style: TextStyle(
              color: PlexColorPalette.gamboge,
            ),
          ),
          TextSpan(text: '   '),
          TextSpan(
            text: childTitle,
            style: TextStyle(
              color: TautulliColorPalette.not_white,
            ),
          ),
          TextSpan(
            text: childCount,
            style: TextStyle(
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
            text: 'PLAYS ',
            style: TextStyle(
              color: TautulliColorPalette.not_white,
            ),
          ),
          TextSpan(
            text: library.plays.toString(),
            style: TextStyle(
              color: PlexColorPalette.gamboge,
            ),
          ),
          TextSpan(text: '   '),
          if (durationMap['day'] > 1 ||
              durationMap['hour'] > 1 ||
              durationMap['min'] > 1 ||
              durationMap['sec'] > 1)
            TextSpan(
              text: 'DURATION ',
              style: TextStyle(
                color: TautulliColorPalette.not_white,
              ),
            ),
          if (durationMap['day'] > 0)
            TextSpan(
              children: [
                TextSpan(
                  text: durationMap['day'].toString(),
                  style: TextStyle(
                    color: PlexColorPalette.gamboge,
                  ),
                ),
                TextSpan(
                  text: ' days ',
                  style: TextStyle(
                    color: TautulliColorPalette.not_white,
                  ),
                ),
              ],
            ),
          if (durationMap['hour'] > 0)
            TextSpan(
              children: [
                TextSpan(
                  text: durationMap['hour'].toString(),
                  style: TextStyle(
                    color: PlexColorPalette.gamboge,
                  ),
                ),
                TextSpan(
                  text: ' hrs ',
                  style: TextStyle(
                    color: TautulliColorPalette.not_white,
                  ),
                ),
              ],
            ),
          if (durationMap['min'] > 0)
            TextSpan(
              children: [
                TextSpan(
                  text: durationMap['min'].toString(),
                  style: TextStyle(
                    color: PlexColorPalette.gamboge,
                  ),
                ),
                TextSpan(
                  text: ' mins',
                  style: TextStyle(
                    color: TautulliColorPalette.not_white,
                  ),
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
                  style: TextStyle(
                    color: PlexColorPalette.gamboge,
                  ),
                ),
                TextSpan(
                  text: ' secs',
                  style: TextStyle(
                    color: TautulliColorPalette.not_white,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
