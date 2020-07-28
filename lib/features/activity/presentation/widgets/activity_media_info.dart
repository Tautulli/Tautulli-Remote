import 'package:flutter/material.dart';

class ActivityMediaInfo extends StatelessWidget {
  final String mediaType;
  final String title;
  final String parentTitle;
  final String grandparentTitle;
  final int year;
  final int mediaIndex;
  final int parentMediaIndex;
  final int live;
  final String originallyAvailableAt;

  const ActivityMediaInfo({
    Key key,
    @required this.mediaType,
    @required this.title,
    @required this.parentTitle,
    @required this.grandparentTitle,
    @required this.year,
    @required this.mediaIndex,
    @required this.parentMediaIndex,
    @required this.live,
    @required this.originallyAvailableAt,
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
            mediaType == 'episode'
                ? _ActivityMediaInfoH1(
                    text: grandparentTitle,
                    maxLines: 1,
                  )
                : mediaType == 'movie'
                    ? _ActivityMediaInfoH1(
                        text: title,
                        maxLines: 3,
                      )
                    : _ActivityMediaInfoH1(
                        text: title,
                        maxLines: 2,
                      ),
            mediaType == 'episode'
                ? _ActivityMediaInfoH2(text: title)
                : mediaType == 'track'
                    ? _ActivityMediaInfoH2(
                        text: grandparentTitle,
                        maxLines: 1,
                      )
                    : Container(),
            mediaType == 'movie' && year != null
                ? _ActivityMediaInfoH3(text: year.toString())
                : mediaType == 'episode' &&
                        parentMediaIndex != null &&
                        mediaIndex != null
                    ? _ActivityMediaInfoH3(
                        text: 'S$parentMediaIndex • E$mediaIndex')
                    : mediaType == 'episode' &&
                            originallyAvailableAt != null &&
                            live == 1
                        ? _ActivityMediaInfoH3(text: originallyAvailableAt)
                        : mediaType == 'track'
                            ? _ActivityMediaInfoH3(text: parentTitle)
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
