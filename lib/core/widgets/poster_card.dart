// @dart=2.9

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'inherited_headers.dart';
import 'poster_chooser.dart';

class PosterCard extends StatelessWidget {
  final dynamic item;
  final Widget details;
  final Key heroTag;
  final EdgeInsets cardMargin;
  final BorderRadius borderRadius;

  const PosterCard({
    Key key,
    @required this.item,
    @required this.details,
    this.heroTag,
    this.cardMargin,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, String> headerMap = InheritedHeaders.of(context) != null
        ? InheritedHeaders.of(context).headerMap
        : {};

    return Card(
      margin: cardMargin ?? const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(4),
        child: Container(
          height: 100,
          child: Stack(
            children: [
              Positioned.fill(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: 25,
                    sigmaY: 25,
                  ),
                  child: Image(
                    image: CachedNetworkImageProvider(
                      item.posterUrl != null ? item.posterUrl : '',
                      headers: headerMap,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                color: Colors.black.withOpacity(0.4),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Hero(
                      tag: heroTag ?? UniqueKey(),
                      child: PosterChooser(item: item),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: details,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
