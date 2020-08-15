import 'package:flutter/material.dart';

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Container(
        alignment: Alignment.center,
        height: 115,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
