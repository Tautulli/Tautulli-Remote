import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/icon_helper.dart';
import '../../../../../core/helpers/time_helper.dart';
import '../../../../../core/types/media_type.dart';
import '../../../../../core/widgets/ios/cupertino_card.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../../users/data/models/user_model.dart';
import '../../../../users/presentation/widgets/cupertino/cupertino_style_user_icon.dart';
import '../../../data/models/history_model.dart';
import '../../pages/cupertino/cupertino_style_history_details_page.dart';

class CupertinoStyleHistoryIndividualCard extends StatelessWidget {
  final ServerModel server;
  final HistoryModel history;

  const CupertinoStyleHistoryIndividualCard({
    super.key,
    required this.server,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    final double height = [MediaType.movie, MediaType.otherVideo].contains(history.mediaType) ? 60 : 100;

    return SizedBox(
      height: MediaQuery.of(context).textScaler.scale(1) > 1
          ? height * MediaQuery.of(context).textScaler.scale(1)
          : height,
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => CupertinoStyleHistoryDetailsPage(
              server: server,
              history: history,
              viewMediaEnabled: false,
            ),
          ),
        ),
        child: CupertinoCard(
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CupertinoStyleUserIcon(
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
                                  state.appSettings.maskSensitiveInfo
                                      ? LocaleKeys.hidden_message.tr()
                                      : history.friendlyName ?? '',
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
                                if ([MediaType.episode].contains(history.mediaType) &&
                                    history.parentMediaIndex != null &&
                                    history.mediaIndex != null)
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
            ],
          ),
        ),
      ),
    );
  }
}
