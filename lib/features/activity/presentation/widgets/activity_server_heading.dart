import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/widgets/heading.dart';

class ActivityServerHeading extends StatelessWidget {
  final String serverName;
  final bool loading;

  const ActivityServerHeading({
    super.key,
    required this.serverName,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Heading(text: serverName),
                if (loading)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        color: Theme.of(context).colorScheme.onSurface,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                if (!loading) const Gap(8),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
