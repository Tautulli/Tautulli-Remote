import 'package:flutter/cupertino.dart';

class ChangeTypeIosTag extends StatelessWidget {
  final String type;

  const ChangeTypeIosTag(
    this.type, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;
    Color textColor = CupertinoTheme.of(context).primaryContrastingColor;

    switch (type) {
      case 'important':
        text = 'NOTE';
        color = CupertinoColors.systemRed;
        break;
      case 'new':
        text = 'NEW';
        color = CupertinoTheme.of(context).primaryColor;
        break;
      case 'improvement':
        text = 'IMPR';
        color = CupertinoColors.systemGreen;
        break;
      case 'fix':
        text = 'FIX';
        color = CupertinoColors.systemBrown;
        break;
      default:
        text = '';
        color = CupertinoColors.transparent;
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
