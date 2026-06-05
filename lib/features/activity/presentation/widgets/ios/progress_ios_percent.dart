import 'package:flutter/widgets.dart';

class ProgressIosPercent extends StatelessWidget {
  final int progressPercent;

  const ProgressIosPercent({
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
