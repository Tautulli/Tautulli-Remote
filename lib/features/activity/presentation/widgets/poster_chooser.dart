import 'dart:ui';

import 'package:flutter/material.dart';

import '../../domain/entities/activity.dart';

class PosterChooser extends StatelessWidget {
  final ActivityItem activity;

  const PosterChooser({
    Key key,
    @required this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return activity.mediaType == 'track'
        ? _PosterMusic(
            url: activity.posterUrl,
          )
        : _PosterGeneral(
            url: activity.posterUrl,
          );
  }
}

class _PosterGeneral extends StatelessWidget {
  final String url;

  _PosterGeneral({
    @required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          url,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PosterMusic extends StatelessWidget {
  final String url;

  _PosterMusic({
    @required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Image.network(
                url,
                fit: BoxFit.cover,
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 8,
                sigmaY: 8,
              ),
              child: Center(
                child: Image.network(
                  url,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
