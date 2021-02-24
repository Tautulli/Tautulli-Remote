import 'dart:ui';

import 'package:flutter/material.dart';

class PosterChooser extends StatelessWidget {
  final dynamic item;

  const PosterChooser({
    Key key,
    @required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ['artist', 'album', 'track', 'playlist'].contains(item.mediaType)
        ? _PosterSquare(
            url: item.posterUrl,
          )
        : _PosterGeneral(
            url: item.posterUrl,
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
        child: url != null
            ? Image.network(
                url,
                fit: BoxFit.cover,
              )
            : null,
      ),
    );
  }
}

class _PosterSquare extends StatelessWidget {
  final String url;

  _PosterSquare({
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
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: 8,
                  sigmaY: 8,
                ),
                child: url != null
                    ? Image.network(
                        url,
                        fit: BoxFit.cover,
                      )
                    : Container(),
              ),
            ),
            Center(
              child: url != null
                  ? Image.network(
                      url,
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
