import 'package:flutter/material.dart';

class CheckboxSettingsListTile extends StatelessWidget {
  final bool subtitleIsTwoLines;
  final Widget leading;
  final String title;
  final String? subtitle;
  final bool value;
  final Function(bool?)? onChanged;

  const CheckboxSettingsListTile({
    Key? key,
    this.subtitleIsTwoLines = false,
    required this.leading,
    required this.title,
    this.subtitle,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.primary,
      child: CheckboxListTile(
        secondary: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 35,
              child: leading,
            ),
          ],
        ),
        title: Text(
          title,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                overflow: subtitleIsTwoLines ? null : TextOverflow.ellipsis,
                maxLines: subtitleIsTwoLines ? 2 : 1,
                style: Theme.of(context).textTheme.subtitle2,
              )
            : null,
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
