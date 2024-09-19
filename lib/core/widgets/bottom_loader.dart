import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../error/failure.dart';
import '../types/bloc_status.dart';

class BottomLoader extends StatelessWidget {
  final BlocStatus status;
  final Failure? failure;
  final String? message;
  final String? suggestion;
  final Function()? onTap;

  const BottomLoader({
    super.key,
    required this.status,
    this.failure,
    this.message,
    this.suggestion,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return status != BlocStatus.failure
        ? SizedBox(
            height: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (message != null)
                              Text(
                                message!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            if (message != null) const Gap(4),
                            const FaIcon(
                              FontAwesomeIcons.arrowRotateRight,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
