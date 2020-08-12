import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:quiver/strings.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/helpers/string_format_helper.dart';
import '../../../../core/widgets/failure_alert_dialog.dart';
import '../../../../core/widgets/poster_chooser.dart';
import '../../../terminate_session/presentation/bloc/terminate_session_bloc.dart';
import '../../domain/entities/activity.dart';
import '../bloc/activity_bloc.dart';
import 'activity_media_icon_row.dart';
import 'activity_media_info.dart';
import 'activity_modal_bottom_sheet.dart';
import 'background_image_chooser.dart';
import 'custom_bottom_sheet.dart' as customBottomSheet;
import 'platform_icon.dart';
import 'progress_bar.dart';
import 'status_poster_overlay.dart';
import 'terminate_session_button.dart';
import 'time_left.dart';

class ActivityCard extends StatefulWidget {
  final Map<String, Map<String, Object>> activityMap;
  final int index;
  final String tautulliId;
  final SlidableController slidableController;

  const ActivityCard({
    Key key,
    @required this.activityMap,
    @required this.index,
    @required this.tautulliId,
    @required this.slidableController,
  }) : super(key: key);

  @override
  _ActivityCardState createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  @override
  Widget build(BuildContext context) {
    final List activityList = widget.activityMap[widget.tautulliId]['activity'];
    final ActivityItem activity = activityList[widget.index];

    final _terminateMessageController = TextEditingController();

    final activityBloc = BlocProvider.of<ActivityBloc>(context);
    final terminateSessionBloc = BlocProvider.of<TerminateSessionBloc>(context);

    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dx < 0) {
          if (activity.mediaType == 'photo') {
            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(
              SnackBar(
                backgroundColor: PlexColorPalette.shark,
                content: Text('Photo streams cannot be terminated.'),
              ),
            );
          } else if (isEmpty(activity.sessionId)) {
            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(
              SnackBar(
                backgroundColor: PlexColorPalette.shark,
                content: Text('Synced content cannot be terminated.'),
              ),
            );
          }
        }
      },
      onTap: () {
        showActivityModalBottomSheet(
          context: context,
          activityBloc: activityBloc,
          activity: activity,
          tautulliId: widget.tautulliId,
        );
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Slidable.builder(
            key: ValueKey('${widget.tautulliId}:${activity.sessionId}'),
            controller: widget.slidableController,
            actionPane: SlidableBehindActionPane(),
            secondaryActionDelegate: isNotEmpty(activity.sessionId)
                ? SlideActionBuilderDelegate(
                    actionCount: 1,
                    builder: (context, index, animation, step) {
                      return BlocListener<TerminateSessionBloc,
                          TerminateSessionState>(
                        listener: (context, state) {
                          if (state is TerminateSessionSuccess) {
                            state.slidableState.close();
                            Scaffold.of(context).hideCurrentSnackBar();
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.green,
                                content:
                                    Text('Termination request sent to Plex.'),
                                //TODO: Link action to help or wiki
                                action: SnackBarAction(
                                  label: 'Learn more',
                                  onPressed: () {},
                                  textColor: Colors.white,
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
                        child: SlideAction(
                          closeOnTap: false,
                          onTap: () async {
                            final confirm = await _showTerminateSessionDialog(
                              context: context,
                              controller: _terminateMessageController,
                              activity: activity,
                            );
                            if (confirm == 1) {
                              terminateSessionBloc.add(
                                TerminateSessionStarted(
                                  slidableState: Slidable.of(context),
                                  tautulliId: widget.tautulliId,
                                  sessionId: activity.sessionId,
                                  message: _terminateMessageController.text !=
                                          null
                                      ? _terminateMessageController.text
                                      : 'The server owner has ended the stream.',
                                ),
                              );
                            } else {
                              Slidable.of(context).close();
                            }
                          },
                          color: Theme.of(context).errorColor,
                          child: BlocBuilder<TerminateSessionBloc,
                              TerminateSessionState>(
                            builder: (context, state) {
                              if (state is TerminateSessionInProgress &&
                                  state.sessionId == activity.sessionId) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        TautulliColorPalette.not_white),
                                  ),
                                );
                              }
                              return TerminateSessionButton();
                            },
                          ),
                        ),
                      );
                    },
                  )
                : null,
            child: Card(
              // Override Card margin so slidable can display properly
              margin: const EdgeInsets.all(0),
              elevation: 2,
              // ClipRRect prevents the ImageFilter from affecting the parents (slidable)
              child: ClipRRect(
                child: SizedBox(
                  height: 135,
                  child: Stack(
                    children: <Widget>[
                      //* Background art layer
                      LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return Container(
                            width: constraints.maxWidth,
                            child: BackgroundImageChooser(
                              activity: activity,
                            ),
                          );
                        },
                      ),
                      // BackdropFilter for frosted glass effect
                      BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 25,
                          sigmaY: 25,
                        ),
                        //* Foreground information layer
                        child: Column(
                          children: <Widget>[
                            //* Main information area
                            Container(
                              height: 130,
                              padding: const EdgeInsets.all(4),
                              child: Row(
                                children: <Widget>[
                                  //* Poster section
                                  Stack(
                                    children: <Widget>[
                                      //* Poster
                                      Container(
                                        height: 130,
                                        child: PosterChooser(
                                          item: activity,
                                        ),
                                      ),
                                      //* Current state poster overlay
                                      if (activity.state == 'paused' ||
                                          activity.state == 'buffering')
                                        StatusPosterOverlay(
                                            state: activity.state),
                                    ],
                                  ),
                                  //* Info section
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 6),
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                //* Activity info
                                                Expanded(
                                                  child: ActivityMediaInfo(
                                                    activity: activity,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 50,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      //* Platform icon
                                                      PlatformIcon(activity
                                                          .platformName),
                                                      //* Media Type and Transcode Decision Icons (except photo)
                                                      if (activity.mediaType !=
                                                          'photo')
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            bottom: 3,
                                                          ),
                                                          child:
                                                              ActivityMediaIconRow(
                                                                  activity:
                                                                      activity),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              //* User name
                                              Text(activity.friendlyName),
                                              //* Time left or Live tv channel
                                              //* or Photo Media Type and Transcode Decision Icons
                                              activity.live == 0 &&
                                                      activity.duration != null
                                                  ? TimeLeft(
                                                      duration:
                                                          activity.duration,
                                                      progressPercent: activity
                                                          .progressPercent,
                                                    )
                                                  : activity.live == 1
                                                      ? Text(
                                                          '${activity.channelCallSign} ${activity.channelIdentifier}')
                                                      : activity.mediaType ==
                                                              'photo'
                                                          ? ActivityMediaIconRow(
                                                              activity:
                                                                  activity)
                                                          : Container(
                                                              height: 0,
                                                              width: 0),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //* Progress bar
                            Container(
                              height: 5,
                              child: activity.mediaType == 'photo' ||
                                      activity.live == 1
                                  ? ProgressBar(
                                      progress: 100,
                                      transcodeProgress: 0,
                                    )
                                  : ProgressBar(
                                      progress: activity.progressPercent,
                                      transcodeProgress:
                                          activity.transcodeProgress,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showActivityModalBottomSheet({
  @required BuildContext context,
  @required ActivityBloc activityBloc,
  @required ActivityItem activity,
  @required String tautulliId,
}) {
  customBottomSheet.showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (builderContext) {
      return BlocProvider<ActivityBloc>.value(
        value: activityBloc,
        child: ActivityModalBottomSheet(
          activity: activity,
          tautulliId: tautulliId,
        ),
      );
    },
  );
}

Future<int> _showTerminateSessionDialog({
  @required BuildContext context,
  @required TextEditingController controller,
  @required ActivityItem activity,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text('Are you sure you want to terminate this stream?'),
        content: IntrinsicHeight(
          child: Column(
            children: <Widget>[
              _TerminateSessionMediaInfo(activity: activity),
              TextFormField(
                controller: controller,
                maxLines: 2,
                decoration: InputDecoration(
                    helperText: 'Terminate Message',
                    hintText: 'The server owner has ended the stream.'),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop(0);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: FlatButton(
              child: Text('TERMINATE'),
              color: Colors.red,
              onPressed: () {
                Navigator.of(context).pop(1);
              },
            ),
          ),
        ],
      );
    },
  );
}

class _TerminateSessionMediaInfo extends StatelessWidget {
  final ActivityItem activity;

  const _TerminateSessionMediaInfo({
    Key key,
    @required this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String row1;
    String row2;
    String row3;

    switch (activity.mediaType) {
      case ('movie'):
        if (activity.title != null) {
          row1 = activity.title;
        }
        if (activity.year != null) {
          row2 = activity.year.toString();
        }
        break;
      case ('episode'):
        if (activity.grandparentTitle != null) {
          row1 = activity.grandparentTitle;
        }
        if (activity.title != null) {
          row2 = activity.title;
        }
        if (activity.parentMediaIndex != null && activity.mediaIndex != null) {
          row3 = 'S${activity.parentMediaIndex} • E${activity.mediaIndex}';
        } else if (activity.originallyAvailableAt != null &&
            activity.live == 1) {
          row3 = activity.originallyAvailableAt;
        }
        break;
      case ('track'):
        if (activity.title != null) {
          row1 = activity.title;
        }
        if (activity.grandparentTitle != null) {
          row2 = activity.grandparentTitle;
        }
        if (activity.parentTitle != null) {
          row3 = activity.parentTitle;
        }
        break;
      case ('clip'):
        if (activity.title != null) {
          row1 = activity.title;
        }
        if (activity.subType != null) {
          row2 = '(${StringFormatHelper.capitalize(activity.subType)})';
        }
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        children: <Widget>[
          Text(
            activity.friendlyName,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
          if (row1 != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                row1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          if (row2 != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                row2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          if (row3 != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                row3,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
