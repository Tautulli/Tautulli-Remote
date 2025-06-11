import 'package:flutter/cupertino.dart';

class CustomCupertinoNavigationBarBackButton extends StatelessWidget {
  final String? previousPageTitle;

  const CustomCupertinoNavigationBarBackButton({
    super.key,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBarBackButton(
      //TODO: Eventually remove workaround for https://github.com/flutter/flutter/issues/89888
      previousPageTitle: previousPageTitle,
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}
