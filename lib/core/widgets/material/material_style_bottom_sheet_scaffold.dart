import 'package:flutter/material.dart';

import 'material_style_gesture_pill.dart';

class MaterialStyleBottomSheetScaffold extends StatelessWidget {
  final String title;
  final Widget? leading;
  final Widget? trailing;
  final Widget child;

  const MaterialStyleBottomSheetScaffold({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 12),
          child: MaterialStyleGesturePill(),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          height: 44,
          child: NavigationToolbar(
            leading: leading,
            middle: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: trailing,
          ),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.6,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: child,
            ),
          ),
        ),
        SizedBox(height: MediaQuery.paddingOf(context).bottom + 8),
      ],
    );
  }
}
