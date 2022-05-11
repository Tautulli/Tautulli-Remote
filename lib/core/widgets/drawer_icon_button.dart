import 'package:flutter/material.dart';

class DrawerIconButton extends StatelessWidget {
  final Widget icon;
  final Function()? onPressed;
  final bool selected;

  const DrawerIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (selected)
          Positioned.fromRelativeRect(
            rect: const RelativeRect.fromLTRB(2, 2, 2, 2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                color: HSLColor.fromColor(
                  Theme.of(context).listTileTheme.tileColor!,
                ).withLightness(0.25).toColor(),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                icon: icon,
                onPressed: onPressed,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
