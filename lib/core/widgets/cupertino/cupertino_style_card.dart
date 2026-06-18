import 'package:flutter/cupertino.dart';
import 'package:tautulli_remote/core/helpers/color_palette_helper.dart';


class CupertinoStyleCard extends StatelessWidget {
  final Widget child;
  final double? horizontalPadding;
  final Color? tint;
  final bool showLoading;

  const CupertinoStyleCard({
    super.key,
    required this.child,
    this.horizontalPadding,
    this.tint,
    this.showLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 0),
      child: ClipRSuperellipse(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          color: CupertinoColors.systemBackground.darkElevatedColor,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Container(
                  color: tint?.withAlpha(175) ?? TautulliColorPalette.smoke.withAlpha(22),
                ),
              ),
              child,
              if (showLoading)
                Positioned.fill(
                  child: Container(
                    color: CupertinoColors.black.withValues(alpha: 0.30),
                    child: const Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
