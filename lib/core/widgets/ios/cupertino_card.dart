import 'package:flutter/cupertino.dart';

import '../../helpers/theme_helper.dart';

class CupertinoCard extends StatelessWidget {
  final Widget child;
  final double? horizontalPadding;
  final Color? tint;
  final bool showLoading;

  const CupertinoCard({
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
            children: [
              Positioned.fill(
                child: Container(
                  color: tint?.withAlpha(175),
                ),
              ),
              child,
              if (showLoading)
                Positioned.fill(
                  child: Container(
                    color: ThemeHelper.darkenedColor(
                      CupertinoTheme.of(context).scaffoldBackgroundColor,
                    ).withValues(alpha: 0.40),
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
