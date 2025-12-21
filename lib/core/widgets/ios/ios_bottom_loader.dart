import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

import '../../error/failure.dart';
import '../../types/bloc_status.dart';

class IosBottomLoader extends StatelessWidget {
  final BlocStatus status;
  final Failure? failure;
  final String? message;
  final String? suggestion;
  final Function()? onTap;

  const IosBottomLoader({
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
        ? const SizedBox(
            height: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoActivityIndicator(),
              ],
            ),
          )
        : ClipRSuperellipse(
            borderRadius: BorderRadius.circular(12),
            child: GestureDetector(
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
                          const Icon(
                            CupertinoIcons.goforward,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
