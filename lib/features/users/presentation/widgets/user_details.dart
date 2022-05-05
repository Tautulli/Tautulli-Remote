import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/helpers/time_helper.dart';
import '../../data/models/user_model.dart';

class UserDetails extends StatelessWidget {
  final UserModel user;

  const UserDetails({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.friendlyName ?? 'name missing',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Streamed ',
              ),
              TextSpan(
                text: user.lastSeen != null
                    ? TimeHelper.timeAgo(user.lastSeen)
                    : 'never',
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        _playsAndDuration(),
      ],
    );
  }

  Widget _playsAndDuration() {
    Map<String, int> durationMap = TimeHelper.durationMap(
      Duration(seconds: user.duration ?? 0),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Plays ',
                  ),
                  TextSpan(
                    text: user.plays.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Gap(8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    if (durationMap['day']! > 1 ||
                        durationMap['hour']! > 1 ||
                        durationMap['min']! > 1 ||
                        durationMap['sec']! > 1)
                      const TextSpan(
                        text: 'Duration ',
                      ),
                    if (durationMap['day']! > 0)
                      TextSpan(
                        children: [
                          TextSpan(
                            text: durationMap['day'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                            ),
                          ),
                          const TextSpan(
                            text: ' days ',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    if (durationMap['hour']! > 0)
                      TextSpan(
                        children: [
                          TextSpan(
                            text: durationMap['hour'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                            ),
                          ),
                          const TextSpan(
                            text: ' hrs ',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    if (durationMap['min']! > 0)
                      TextSpan(
                        children: [
                          TextSpan(
                            text: durationMap['min'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                            ),
                          ),
                          const TextSpan(
                            text: ' mins',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    if (durationMap['day']! < 1 &&
                        durationMap['hour']! < 1 &&
                        durationMap['min']! < 1 &&
                        durationMap['sec']! > 0)
                      TextSpan(
                        children: [
                          TextSpan(
                            text: durationMap['sec'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                            ),
                          ),
                          const TextSpan(
                            text: ' secs',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
