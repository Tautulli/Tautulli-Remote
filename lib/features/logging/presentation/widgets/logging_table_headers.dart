import 'package:flutter/material.dart';

class LoggingTableHeaders extends StatelessWidget {
  const LoggingTableHeaders({super.key});

  @override
  Widget build(BuildContext context) {
    const double textSize = 13;

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.black54,
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            padding: const EdgeInsets.only(
              top: 14,
              bottom: 14,
              left: 12,
            ),
            child: const Text(
              'Timestamp',
              style: TextStyle(
                fontSize: textSize,
              ),
            ),
          ),
          Container(
            width: 86,
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 6,
            ),
            child: const Text(
              'Level',
              style: TextStyle(
                fontSize: textSize,
              ),
            ),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: 8,
                bottom: 8,
                left: 6,
                right: 12,
              ),
              child: Text(
                'Message',
                style: TextStyle(
                  fontSize: textSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
