import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:tautulli_remote/core/widgets/ios/heading_ios.dart';

class ActivityIosServerHeading extends StatelessWidget {
  final String serverName;
  final bool loading;

  const ActivityIosServerHeading({
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
            // color: Theme.of(context).colorScheme.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    //TODO: Add heading
                    HeadingIos(text: serverName),
                    //TODO: Add loading indicator
                    if (loading)
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: CupertinoActivityIndicator(radius: 8),
                      ),
                    //   Padding(
                    //     padding: const EdgeInsets.symmetric(vertical: 2),
                    //     child: ClipRRect(
                    //       borderRadius: BorderRadius.circular(2),
                    //       child: LinearProgressIndicator(
                    //         color: Theme.of(context).colorScheme.onSurface,
                    //         backgroundColor: Colors.transparent,
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),

                // if (!loading)
                const Gap(8),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
