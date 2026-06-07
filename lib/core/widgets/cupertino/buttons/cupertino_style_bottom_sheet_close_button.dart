import 'package:flutter/cupertino.dart';

class CupertinoStyleBottomSheetCloseButton extends StatelessWidget {
  final Function() onPressed;

  const CupertinoStyleBottomSheetCloseButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(0),
      onPressed: onPressed,
      child: const Icon(CupertinoIcons.clear_thick),
    );
  }
}
