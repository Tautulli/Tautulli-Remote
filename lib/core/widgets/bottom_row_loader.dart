import 'package:flutter/material.dart';

class BottomRowLoader extends StatelessWidget {
  final int index;

  const BottomRowLoader({
    @required this.index,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.black26 : null,
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 16,
        ),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
