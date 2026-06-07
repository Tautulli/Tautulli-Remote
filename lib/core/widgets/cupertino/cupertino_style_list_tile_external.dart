import 'package:flutter/cupertino.dart';

class CupertinoStyleListTileExternal extends StatelessWidget {
  const CupertinoStyleListTileExternal({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      CupertinoIcons.square_arrow_up,
      size: CupertinoTheme.of(context).textTheme.textStyle.fontSize,
      color: CupertinoColors.systemGrey2.resolveFrom(context),
    );
  }
}
