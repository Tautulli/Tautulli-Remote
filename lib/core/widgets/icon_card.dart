import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:websafe_svg/websafe_svg.dart';

class IconCard extends StatelessWidget {
  final String localIconImagePath;
  final String iconImageUrl;
  final Color backgroundColor;
  final Color iconColor;
  final Image backgroundImage;
  final Widget details;

  const IconCard({
    Key key,
    this.localIconImagePath,
    this.iconImageUrl,
    this.backgroundColor,
    this.iconColor,
    this.backgroundImage,
    this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    AspectRatio(
                      aspectRatio: 2 / 3,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: iconImageUrl != null
                            ? Image.network(
                                iconImageUrl,
                                fit: BoxFit.contain,
                              )
                            : localIconImagePath != null
                                ? WebsafeSvg.asset(
                                    localIconImagePath,
                                    color: iconColor,
                                  )
                                : null,
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
