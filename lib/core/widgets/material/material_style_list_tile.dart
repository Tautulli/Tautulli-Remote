import 'package:flutter/material.dart';

import '../base/sensitive_text.dart';

class MaterialStyleListTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Function()? onTap;
  final Function()? onLongPress;
  final bool inactive;
  final bool sensitive;

  const MaterialStyleListTile({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.inactive = false,
    this.sensitive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ElevationOverlay.applySurfaceTint(
        Theme.of(context).colorScheme.surface,
        Theme.of(context).colorScheme.surfaceTint,
        1,
      ),
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              child: Center(
                child: leading,
              ),
            ),
          ],
        ),
        title: Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: inactive ? Theme.of(context).disabledColor : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: inactive
                      ? Theme.of(context).disabledColor
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ).sensitive(enabled: sensitive)
            : null,
        trailing: trailing,
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}
