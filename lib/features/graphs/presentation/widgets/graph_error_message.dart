import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

class GraphErrorMessage extends StatelessWidget {
  final String message;
  final String suggestion;

  const GraphErrorMessage({
    Key key,
    this.message,
    this.suggestion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Failed to load graph',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          if (isNotEmpty(message) || isNotEmpty(suggestion))
            const SizedBox(height: 4),
          if (isNotEmpty(message))
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          if (isNotEmpty(suggestion))
            Text(
              suggestion,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
        ],
      ),
    );
  }
}
