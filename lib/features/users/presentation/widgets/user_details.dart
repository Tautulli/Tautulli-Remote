import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/helpers/time_helper.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/user_model.dart';

class UserDetails extends StatelessWidget {
  final UserModel user;

  const UserDetails({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;

            return Text(
              state.appSettings.maskSensitiveInfo
                  ? LocaleKeys.hidden_message.tr()
                  : user.friendlyName ?? 'name missing',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            );
          },
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: LocaleKeys.streamed_title.tr(),
              ),
              const TextSpan(
                text: ' ',
              ),
              TextSpan(
                text: user.lastSeen != null
                    ? TimeHelper.moment(user.lastSeen)
                    : LocaleKeys.never.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 13,
                  color: Colors.grey[200],
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
                  TextSpan(
                    text: LocaleKeys.plays_title.tr(),
                  ),
                  const TextSpan(
                    text: ' ',
                  ),
                  TextSpan(
                    text: user.plays.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 13,
                      color: Colors.grey[200],
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
                      TextSpan(
                        text: '${LocaleKeys.time_title.tr()} ',
                      ),
                    if (durationMap['day']! > 0)
                      TextSpan(
                        children: [
                          TextSpan(
                            text: durationMap['day'].toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                              color: Colors.grey[200],
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
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                              color: Colors.grey[200],
                            ),
                          ),
                          TextSpan(
                            text: ' hrs ',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                              color: Colors.grey[200],
                            ),
                          ),
                        ],
                      ),
                    if (durationMap['min']! > 0)
                      TextSpan(
                        children: [
                          TextSpan(
                            text: durationMap['min'].toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                              color: Colors.grey[200],
                            ),
                          ),
                          TextSpan(
                            text: ' mins',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                              color: Colors.grey[200],
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
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                              color: Colors.grey[200],
                            ),
                          ),
                          TextSpan(
                            text: ' secs',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                              color: Colors.grey[200],
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
