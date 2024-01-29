import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/helpers/icon_helper.dart';
import '../../../../core/helpers/time_helper.dart';
import '../../../../core/types/media_type.dart';
import '../../../../core/widgets/card_with_forced_tint.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../geo_ip/presentation/bloc/geo_ip_bloc.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../users/data/models/user_model.dart';
import '../../../users/presentation/widgets/user_icon.dart';
import '../../data/models/history_model.dart';
import 'history_bottom_sheet.dart';

class HistoryIndividualCard extends StatelessWidget {
  final ServerModel server;
  final HistoryModel history;

  const HistoryIndividualCard({
    super.key,
    required this.server,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    final double height = [MediaType.movie, MediaType.otherVideo].contains(history.mediaType) ? 60 : 100;

    return SizedBox(
      height: MediaQuery.of(context).textScaler.scale(1) > 1 ? height * MediaQuery.of(context).textScaler.scale(1) : height,
      child: CardWithForcedTint(
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    UserIcon(
                      disableHero: true,
                      user: UserModel(
                        userId: history.userId,
                        userThumb: history.userThumb,
                      ),
                    ),
                    const Gap(8),
                    Expanded(
                      child: BlocBuilder<SettingsBloc, SettingsState>(
                        builder: (context, state) {
                          state as SettingsSuccess;

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.appSettings.maskSensitiveInfo ? LocaleKeys.hidden_message.tr() : history.friendlyName ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if ([
                                MediaType.episode,
                                MediaType.track,
                              ].contains(history.mediaType))
                                Text(
                                  history.title ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              if ([MediaType.episode].contains(history.mediaType) && history.parentMediaIndex != null && history.mediaIndex != null)
                                Text('S${history.parentMediaIndex} • E${history.mediaIndex}'),
                              if ([MediaType.track].contains(history.mediaType))
                                Text(
                                  history.parentTitle ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              Text(
                                TimeHelper.cleanDateTime(
                                  history.date!,
                                  dateFormat: state.appSettings.activeServer.dateFormat,
                                  timeFormat: state.appSettings.activeServer.timeFormat,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    IconHelper.mapWatchedStatusToIcon(
                      context: context,
                      watchedStatus: history.watchedStatus,
                    ),
                  ],
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => showModalBottomSheet(
                  context: context,
                  constraints: const BoxConstraints(
                    maxWidth: 500,
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  isScrollControlled: true,
                  builder: (context) {
                    return BlocProvider.value(
                      value: context.read<GeoIpBloc>(),
                      child: HistoryBottomSheet(
                        server: server,
                        history: history,
                        viewUserEnabled: true,
                        viewMediaEnabled: false,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
