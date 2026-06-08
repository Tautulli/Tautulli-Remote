import 'package:flutter/widgets.dart';

//! Use a shared widget when the material style gets an update
class MaterialStyleProgressPercent extends StatelessWidget {
  final int progressPercent;

  const MaterialStyleProgressPercent({
    super.key,
    required this.progressPercent,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$progressPercent%',
      style: const TextStyle(
        fontSize: 13,
      ),
    );
  }
}
