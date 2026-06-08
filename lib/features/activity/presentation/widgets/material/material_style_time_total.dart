import 'package:flutter/widgets.dart';

import '../../../../../core/helpers/time_helper.dart';

//! Use a shared widget when the material style gets an update
class MaterialStyleTimeTotal extends StatelessWidget {
  final int viewOffset;
  final Duration duration;

  const MaterialStyleTimeTotal({
    super.key,
    required this.viewOffset,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '${TimeHelper.hourMinSec(Duration(milliseconds: viewOffset))}/${TimeHelper.hourMinSec(duration)}',
      style: const TextStyle(
        fontSize: 13,
      ),
    );
  }
}
