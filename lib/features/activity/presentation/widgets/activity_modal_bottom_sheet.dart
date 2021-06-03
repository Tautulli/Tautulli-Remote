import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/failure_alert_dialog.dart';
import '../../../../core/widgets/poster_chooser.dart';
import '../../../media/domain/entities/media_item.dart';
import '../../../media/presentation/pages/media_item_page.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../terminate_session/presentation/bloc/terminate_session_bloc.dart';
import '../../../terminate_session/presentation/widgets/terminate_session_dialog.dart';
import '../../../users/domain/entities/user_table.dart';
import '../../../users/presentation/pages/user_details_page.dart';
import '../../domain/entities/activity.dart';
import '../bloc/activity_bloc.dart';
import 'activity_media_details.dart';
import 'activity_media_info.dart';
import 'background_image_chooser.dart';
import 'progress_bar.dart';
import 'status_poster_overlay.dart';
import 'time_eta.dart';
import 'time_total.dart';

class ActivityModalBottomSheet extends StatefulWidget {
  final ActivityItem activity;
  final String tautulliId;
  final String timeFormat;
  final bool showTerminateButton;
  final TextEditingController terminateMessageController;

  const ActivityModalBottomSheet({
    Key key,
    @required this.activity,
    @required this.tautulliId,
    @required this.timeFormat,
    @required this.showTerminateButton,
    @required this.terminateMessageController,
  }) : super(key: key);

  @override
  _ActivityModalBottomSheetState createState() =>
      _ActivityModalBottomSheetState();
}

class _ActivityModalBottomSheetState extends State<ActivityModalBottomSheet> {
  ActivityItem activity;

  @override
  void initState() {
    super.initState();
    activity = widget.activity;
  }

  @override
  Widget build(BuildContext context) {
    final settingsBloc = context.read<SettingsBloc>();
    final SettingsLoadSuccess settingsLoadSuccess = settingsBloc.state;
    final terminateSessionBloc = context.read<TerminateSessionBloc>();

    return MultiBlocListener(
      listeners: [
        BlocListener<ActivityBloc, ActivityState>(
          listener: (context, state) {
            // Update the activityItem to the lastest data when a new ActivityLoaded is pushed
            if (state is ActivityLoaded) {
              setState(() {
                // If sessionId no longer exists for a given server close the modal
                try {
                  List activityList =
                      state.activityMap[widget.tautulliId]['activityList'];
                  ActivityItem item = activityList.firstWhere(
                      (element) => element.sessionId == activity.sessionId);
                  activity = item;
                } catch (_) {
                  Navigator.of(context).pop();
                }
              });
            }
          },
        ),
        BlocListener<TerminateSessionBloc, TerminateSessionState>(
          listener: (context, state) {
            if (state is TerminateSessionSuccess) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  content: const Text('Termination request sent to Plex.'),
                  action: SnackBarAction(
                    label: 'LEARN MORE',
                    onPressed: () async {
                      await launch(
                        'https://github.com/Tautulli/Tautulli-Remote/wiki/Features#termination_caveats',
                      );
                    },
                    textColor: TautulliColorPalette.not_white,
                  ),
                ),
              );
            }
            if (state is TerminateSessionFailure) {
              showFailureAlertDialog(
                context: context,
                failure: state.failure,
              );
            }
          },
        ),
      ],
      child: Stack(
        children: <Widget>[
          // Use LayoutBulilder to pass constraints to ActivityMediaDetails
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            // Creates a transparent area for the poster to hover over
                            // Allows for that area to be tapped to dismiss the modal bottom sheet
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                height: 30,
                                color: Colors.transparent,
                              ),
                            ),
                            //* Activity art section
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              child: Container(
                                height: 130,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      child: BackgroundImageChooser(
                                        activity: activity,
                                        addBlur: false,
                                      ),
                                    ),
                                    BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 25,
                                        sigmaY: 25,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 4,
                                                left: 98,
                                                bottom: 4,
                                                right: 4,
                                              ),
                                              child: ActivityMediaInfo(
                                                activity: activity,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 4,
                                              left: 98,
                                              top: 4,
                                              bottom: 4,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                //* User name
                                                Text(
                                                  settingsLoadSuccess
                                                          .maskSensitiveInfo
                                                      ? '*Hidden User*'
                                                      : activity.friendlyName,
                                                ),
                                                //* Time left or Live tv channel
                                                activity.live == 0 &&
                                                        activity.duration !=
                                                            null
                                                    ? TimeTotal(
                                                        viewOffset:
                                                            activity.viewOffset,
                                                        duration:
                                                            activity.duration,
                                                      )
                                                    : activity.live == 1
                                                        ? Text(
                                                            '${activity.channelCallSign} ${activity.channelIdentifier}',
                                                          )
                                                        : const SizedBox(),
                                              ],
                                            ),
                                          ),
                                          //* Progress bar
                                          activity.mediaType == 'photo' ||
                                                  activity.live == 1
                                              ? ProgressBar(
                                                  progress: 100,
                                                  transcodeProgress: 0,
                                                )
                                              : ProgressBar(
                                                  progress:
                                                      activity.progressPercent,
                                                  transcodeProgress: activity
                                                      .transcodeProgress,
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        //* Poster
                        Positioned(
                          bottom: 10,
                          child: Container(
                            height: 130,
                            padding: const EdgeInsets.only(
                              left: 4,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Stack(
                                children: <Widget>[
                                  PosterChooser(
                                    item: activity,
                                  ),
                                  if (activity.state == 'paused' ||
                                      activity.state == 'buffering')
                                    StatusPosterOverlay(state: activity.state),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (activity.duration != null)
                          Positioned(
                            right: 4,
                            bottom: 28,
                            child: TimeEta(
                              duration: activity.duration,
                              progressPercent: activity.progressPercent,
                              timeFormat: widget.timeFormat,
                            ),
                          ),
                      ],
                    ),
                    //* Activity details section
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        color: Theme.of(context).backgroundColor,
                        child: ActivityMediaDetails(
                          constraints: constraints,
                          activity: activity,
                          tautulliId: widget.tautulliId,
                        ),
                      ),
                    ),
                    Container(
                      color: Theme.of(context).backgroundColor,
                      child: SafeArea(
                        bottom: !widget.showTerminateButton,
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8,
                                  right: 4,
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    UserTable user = UserTable(
                                      userId: activity.userId,
                                      friendlyName: activity.friendlyName,
                                      userThumb: activity.userThumb,
                                    );

                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => UserDetailsPage(
                                          user: user,
                                          tautulliIdOverride: widget.tautulliId,
                                          forceGetUser: true,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: PlexColorPalette.gamboge,
                                  ),
                                  child: const Text(
                                    'View User',
                                    style: TextStyle(
                                      color: TautulliColorPalette.not_white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (activity.mediaType != 'photo')
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 4,
                                    right: 8,
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      MediaItem mediaItem = MediaItem(
                                        grandparentTitle:
                                            activity.grandparentTitle,
                                        parentMediaIndex:
                                            activity.parentMediaIndex,
                                        mediaIndex: activity.mediaIndex,
                                        mediaType: activity.mediaType,
                                        parentTitle: activity.parentTitle,
                                        posterUrl: activity.posterUrl,
                                        ratingKey: activity.ratingKey,
                                        title: activity.title,
                                        year: activity.year,
                                      );

                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => MediaItemPage(
                                            item: mediaItem,
                                            enableNavOptions: true,
                                            tautulliIdOverride:
                                                widget.tautulliId,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: PlexColorPalette.curious_blue,
                                    ),
                                    child: const Text(
                                      'View Media',
                                      style: TextStyle(
                                        color: TautulliColorPalette.not_white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (widget.showTerminateButton)
                      Container(
                        color: Theme.of(context).backgroundColor,
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 4,
                              left: 8,
                              right: 8,
                              bottom: 8,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).errorColor,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    onPressed: () async {
                                      final confirm =
                                          await showTerminateSessionDialog(
                                        context: context,
                                        controller:
                                            widget.terminateMessageController,
                                        activity: activity,
                                        maskSensitiveInfo: settingsLoadSuccess
                                            .maskSensitiveInfo,
                                      );

                                      if (confirm == 1) {
                                        terminateSessionBloc.add(
                                          TerminateSessionStarted(
                                            tautulliId: widget.tautulliId,
                                            sessionId: activity.sessionId,
                                            message: widget
                                                        .terminateMessageController
                                                        .text !=
                                                    null
                                                ? widget
                                                    .terminateMessageController
                                                    .text
                                                : 'The server owner has ended the stream.',
                                            settingsBloc: settingsBloc,
                                          ),
                                        );
                                      }
                                    },
                                    child: BlocBuilder<TerminateSessionBloc,
                                        TerminateSessionState>(
                                      builder: (context, state) {
                                        if (state
                                            is TerminateSessionInProgress) {
                                          return const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 3,
                                              color: TautulliColorPalette
                                                  .not_white,
                                            ),
                                          );
                                        }
                                        return const Text('Terminate Session');
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
