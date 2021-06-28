import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

import '../../../../translations/locale_keys.g.dart';

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
            LocaleKeys.graphs_load_fail,
            style: TextStyle(
              color: Colors.grey,
            ),
          ).tr(),
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
