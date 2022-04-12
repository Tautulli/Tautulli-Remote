import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Function()? onTap;
  final Widget? trailing;
  final bool selected;

  const DrawerTile({
    Key? key,
    this.leading,
    this.title,
    this.onTap,
    this.trailing,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (selected)
          Positioned.fromRelativeRect(
            rect: const RelativeRect.fromLTRB(0, 0, 10, 0),
            child: ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(30),
              ),
              child: Container(
                color: HSLColor.fromColor(
                  Theme.of(context).listTileTheme.tileColor!,
                ).withLightness(0.25).toColor(),
              ),
            ),
          ),
        ListTile(
          leading: leading,
          title: title,
          onTap: onTap,
          trailing: trailing,
        ),
      ],
    );
  }
}
