import 'package:flutter/material.dart';

import '../../../../core/helpers/string_format_helper.dart';
import '../../domain/entities/activity.dart';

class ActivityMediaInfo extends StatelessWidget {
  final ActivityItem activity;

  const ActivityMediaInfo({
    Key key,
    @required this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(
          right: 3,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            activity.mediaType == 'episode'
                ? _ActivityMediaInfoH1(
                    text: activity.grandparentTitle,
                    maxLines: 1,
                  )
                : activity.mediaType == 'movie'
                    ? _ActivityMediaInfoH1(
                        text: activity.title,
                        maxLines: 3,
                      )
                    : _ActivityMediaInfoH1(
                        text: activity.title,
                        maxLines: 2,
                      ),
            activity.mediaType == 'episode'
                ? _ActivityMediaInfoH2(text: activity.title)
                : activity.mediaType == 'track'
                    ? _ActivityMediaInfoH2(
                        text: activity.grandparentTitle,
                        maxLines: 1,
                      )
                    : Container(),
            activity.mediaType == 'movie' && activity.year != null
                ? _ActivityMediaInfoH3(text: activity.year.toString())
                : activity.mediaType == 'episode' &&
                        activity.parentMediaIndex != null &&
                        activity.mediaIndex != null
                    ? _ActivityMediaInfoH3(
                        text:
                            'S${activity.parentMediaIndex} • E${activity.mediaIndex}')
                    : activity.mediaType == 'episode' &&
                            activity.originallyAvailableAt != null &&
                            activity.live == 1
                        ? _ActivityMediaInfoH3(
                            text: activity.originallyAvailableAt)
                        : activity.mediaType == 'track'
                            ? _ActivityMediaInfoH3(text: activity.parentTitle)
                            : activity.mediaType == 'clip'
                                ? _ActivityMediaInfoH3(
                                    text: '(${StringFormatHelper.capitalize(
                                        activity.subType)})',
                                  )
                                : Container(),
          ],
        ),
      ),
    );
  }
}

class _ActivityMediaInfoH1 extends StatelessWidget {
  final String text;
  final int maxLines;

  const _ActivityMediaInfoH1({
    Key key,
    @required this.text,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines != null ? maxLines : 1,
      style: TextStyle(
        fontSize: 19,
        height: 1,
      ),
    );
  }
}

class _ActivityMediaInfoH2 extends StatelessWidget {
  final String text;
  final int maxLines;

  const _ActivityMediaInfoH2({Key key, @required this.text, this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 5,
      ),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines != null ? maxLines : 2,
        style: TextStyle(
          fontSize: 16,
          height: 1,
        ),
      ),
    );
  }
}

class _ActivityMediaInfoH3 extends StatelessWidget {
  final String text;

  const _ActivityMediaInfoH3({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 5,
      ),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}
