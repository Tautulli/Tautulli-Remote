import 'package:flutter/cupertino.dart';

class CupertinoStyleDivider extends StatelessWidget {
  const CupertinoStyleDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 7, bottom: 8),
      child: Container(height: 1, color: CupertinoColors.systemGrey),
    );
  }
}
