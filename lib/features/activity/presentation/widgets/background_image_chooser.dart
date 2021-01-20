import 'dart:ui';

import 'package:flutter/material.dart';

import '../../domain/entities/activity.dart';

class BackgroundImageChooser extends StatelessWidget {
  final ActivityItem activity;

  const BackgroundImageChooser({
    Key key,
    @required this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: 25,
        sigmaY: 25,
      ),
      child: activity.live == 1
          ? _BackgroundImageLiveTv()
          : _BackgroundImageGeneral(url: activity.posterUrl),
    );
  }
}

class _BackgroundImageGeneral extends StatelessWidget {
  final String url;

  const _BackgroundImageGeneral({
    Key key,
    @required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.network(
            url,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          color: Colors.black.withOpacity(0.4),
        ),
      ],
    );
  }
}

class _BackgroundImageLiveTv extends StatelessWidget {
  const _BackgroundImageLiveTv({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Uses asset image since fallback image from API is pre-blurred
    // Does not add opacity layer as it makes the image too dark
    return Image.asset(
      'assets/images/livetv_fallback.png',
      fit: BoxFit.cover,
    );
  }
}
