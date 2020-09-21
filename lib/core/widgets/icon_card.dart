import 'package:flutter/material.dart';
import 'package:websafe_svg/websafe_svg.dart';

class IconCard extends StatelessWidget {
  final String assetPath;
  final Color backgroundColor;
  final Widget details;

  const IconCard({
    Key key,
    @required this.assetPath,
    this.backgroundColor,
    this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
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
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    AspectRatio(
                      aspectRatio: 2 / 3,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: WebsafeSvg.asset(assetPath),
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
}
