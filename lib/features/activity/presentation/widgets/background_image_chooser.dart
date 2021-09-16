// @dart=2.9

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/inherited_headers.dart';
import '../../domain/entities/activity.dart';

class BackgroundImageChooser extends StatelessWidget {
  final ActivityItem activity;
  final bool addBlur;

  const BackgroundImageChooser({
    Key key,
    @required this.activity,
    this.addBlur = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, String> headerMap = InheritedHeaders.of(context) != null
        ? InheritedHeaders.of(context).headerMap
        : {};

    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: addBlur ? 25 : 0,
        sigmaY: addBlur ? 25 : 0,
      ),
      child: activity.live == 1
          ? const _BackgroundImageLiveTv()
          : _BackgroundImageGeneral(
              url: activity.posterUrl,
              headerMap: headerMap,
            ),
    );
  }
}

class _BackgroundImageGeneral extends StatelessWidget {
  final String url;
  final Map<String, String> headerMap;

  const _BackgroundImageGeneral({
    Key key,
    @required this.url,
    @required this.headerMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image(
            image: CachedNetworkImageProvider(
              url,
              headers: headerMap,
            ),
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
