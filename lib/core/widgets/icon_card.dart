// @dart=2.9

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:websafe_svg/websafe_svg.dart';

import 'inherited_headers.dart';

class IconCard extends StatelessWidget {
  final String localIconImagePath;
  final String iconImageUrl;
  final Widget icon;
  final Color backgroundColor;
  final Color iconColor;
  final Image backgroundImage;
  final Widget details;
  final Key heroTag;

  const IconCard({
    Key key,
    this.localIconImagePath,
    this.iconImageUrl,
    this.icon,
    this.backgroundColor,
    this.iconColor,
    this.backgroundImage,
    this.details,
    this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, String> headerMap = InheritedHeaders.of(context) != null
        ? InheritedHeaders.of(context).headerMap
        : {};

    return Card(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
          children: [
            ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: backgroundImage != null ? 25 : 0,
                sigmaY: backgroundImage != null ? 25 : 0,
              ),
              child: _setBackground(),
            ),
            SizedBox(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Hero(
                      tag: heroTag ?? UniqueKey(),
                      child: AspectRatio(
                        aspectRatio: 2 / 3,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: iconImageUrl != null
                              ? Image(
                                  image: CachedNetworkImageProvider(
                                    iconImageUrl,
                                    headers: headerMap,
                                  ),
                                  fit: BoxFit.contain,
                                )
                              : localIconImagePath != null
                                  ? WebsafeSvg.asset(
                                      localIconImagePath,
                                      color: iconColor,
                                    )
                                  : icon != null
                                      ? Center(child: icon)
                                      : null,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: details,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _setBackground() {
    if (backgroundImage != null) {
      return SizedBox(
        height: 100,
        child: Stack(
          children: [
            Positioned.fill(
              child: backgroundImage,
            ),
            Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ],
        ),
      );
    } else {
      return Stack(
        children: [
          Container(
            height: 100,
            color: backgroundColor,
          ),
          if (backgroundColor != null)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
        ],
      );
    }
  }
}
