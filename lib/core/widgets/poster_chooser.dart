// @dart=2.9

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'inherited_headers.dart';

class PosterChooser extends StatelessWidget {
  final dynamic item;

  const PosterChooser({
    Key key,
    @required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, String> headerMap = InheritedHeaders.of(context) != null
        ? InheritedHeaders.of(context).headerMap
        : {};

    return ['artist', 'album', 'track', 'playlist'].contains(item.mediaType)
        ? _PosterSquare(
            url: item.posterUrl,
            headerMap: headerMap,
          )
        : _PosterGeneral(
            url: item.posterUrl,
            headerMap: headerMap,
          );
  }
}

class _PosterGeneral extends StatelessWidget {
  final String url;
  final Map<String, String> headerMap;

  _PosterGeneral({
    @required this.url,
    @required this.headerMap,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: url != null
            ? Image(
                image: CachedNetworkImageProvider(
                  url,
                  headers: headerMap,
                ),
                fit: BoxFit.cover,
              )
            : null,
      ),
    );
  }
}

class _PosterSquare extends StatelessWidget {
  final String url;
  final Map<String, String> headerMap;

  _PosterSquare({
    @required this.url,
    @required this.headerMap,
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
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: 8,
                  sigmaY: 8,
                ),
                child: url != null
                    ? Image(
                        image: CachedNetworkImageProvider(
                          url,
                          headers: headerMap,
                        ),
                        fit: BoxFit.cover,
                      )
                    : Container(),
              ),
            ),
            Center(
              child: url != null
                  ? Image(
                      image: CachedNetworkImageProvider(
                        url,
                        headers: headerMap,
                      ),
                      fit: BoxFit.contain,
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
