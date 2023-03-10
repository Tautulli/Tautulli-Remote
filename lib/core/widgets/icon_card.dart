import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class IconCard extends StatelessWidget {
  final Widget? background;
  final Widget icon;
  final Widget details;
  final Function()? onTap;

  const IconCard({
    super.key,
    this.background,
    required this.icon,
    required this.details,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).textScaleFactor > 1 ? 100 * MediaQuery.of(context).textScaleFactor : 100,
      child: Card(
        color: background != null ? Colors.transparent : null,
        child: Stack(
          children: [
            if (background != null)
              Positioned.fill(
                child: background!,
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: icon,
                      ),
                    ),
                  ),
                  const Gap(8),
                  Expanded(
                    child: details,
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
