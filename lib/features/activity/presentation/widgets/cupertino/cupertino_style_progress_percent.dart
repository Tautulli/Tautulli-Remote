import 'package:flutter/widgets.dart';

class CupertinoStyleProgressPercent extends StatelessWidget {
  final int progressPercent;

  const CupertinoStyleProgressPercent({
    super.key,
    required this.progressPercent,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$progressPercent%',
    );
  }
}
