import 'package:flutter/cupertino.dart';

/// For use with CupertinoStyleListSection when it's margin has been adjusted.
///
/// If padding is not provided EdgeInsets.only(top: 16, bottom: 6) will be used.
class CupertinoStyleListSectionHeading extends StatelessWidget {
  final String text;
  final EdgeInsets? padding;

  const CupertinoStyleListSectionHeading(
    this.text, {
    super.key,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: padding ?? const EdgeInsets.only(top: 16, bottom: 6),
        child: DefaultTextStyle(
          style: CupertinoTheme.of(context).textTheme.textStyle.merge(
            TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: CupertinoTheme.of(context).primaryColor,
            ),
          ),
          child: Text(text),
        ),
      ),
    );
  }
}
