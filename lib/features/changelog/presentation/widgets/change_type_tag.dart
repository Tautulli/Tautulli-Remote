import 'package:flutter/material.dart';

class ChangeTypeTag extends StatelessWidget {
  final String type;

  const ChangeTypeTag(
    this.type, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;
    Color? textColor;

    switch (type) {
      case 'important':
        text = 'NOTE';
        color = Theme.of(context).colorScheme.errorContainer;
        textColor = Theme.of(context).colorScheme.onErrorContainer;
        break;
      case 'new':
        text = 'NEW';
        color = Theme.of(context).colorScheme.primary;
        textColor = Theme.of(context).colorScheme.onPrimary;
        break;
      case 'improvement':
        text = 'IMPR';
        color = Theme.of(context).colorScheme.secondaryContainer;
        textColor = Theme.of(context).colorScheme.onSecondaryContainer;
        break;
      case 'fix':
        text = 'FIX';
        color = Theme.of(context).colorScheme.tertiaryContainer;
        textColor = Theme.of(context).colorScheme.onTertiaryContainer;
        break;
      default:
        text = '';
        color = Colors.transparent;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 40,
          decoration: BoxDecoration(
            color: color,
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
