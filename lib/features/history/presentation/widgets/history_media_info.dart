import 'package:flutter/material.dart';

import '../../domain/entities/history.dart';

class HistoryMediaInfo extends StatelessWidget {
  final History history;

  const HistoryMediaInfo({
    Key key,
    @required this.history,
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
            history.mediaType == 'episode'
                ? _HistoryMediaInfoH1(
                    text: history.grandparentTitle,
                    maxLines: 1,
                  )
                : history.mediaType == 'movie'
                    ? _HistoryMediaInfoH1(
                        text: history.title,
                        maxLines: 3,
                      )
                    : _HistoryMediaInfoH1(
                        text: history.title,
                        maxLines: 2,
                      ),
            history.mediaType == 'episode'
                ? _HistoryMediaInfoH2(text: history.title)
                : history.mediaType == 'track'
                    ? _HistoryMediaInfoH2(
                        text: history.grandparentTitle,
                        maxLines: 1,
                      )
                    : Container(),
            history.mediaType == 'movie' && history.year != null
                ? _HistoryMediaInfoH3(text: history.year.toString())
                : history.mediaType == 'episode' &&
                        history.parentMediaIndex != null &&
                        history.mediaIndex != null
                    ? _HistoryMediaInfoH3(
                        text:
                            'S${history.parentMediaIndex} • E${history.mediaIndex}')
                    : history.mediaType == 'track'
                        ? _HistoryMediaInfoH3(text: history.parentTitle)
                        : Container(),
          ],
        ),
      ),
    );
  }
}

class _HistoryMediaInfoH1 extends StatelessWidget {
  final String text;
  final int maxLines;

  const _HistoryMediaInfoH1({
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
      style: const TextStyle(
        fontSize: 19,
        height: 1,
      ),
    );
  }
}

class _HistoryMediaInfoH2 extends StatelessWidget {
  final String text;
  final int maxLines;

  const _HistoryMediaInfoH2({Key key, @required this.text, this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
      ),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines != null ? maxLines : 2,
        style: const TextStyle(
          fontSize: 16,
          height: 1,
        ),
      ),
    );
  }
}

class _HistoryMediaInfoH3 extends StatelessWidget {
  final String text;

  const _HistoryMediaInfoH3({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
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
