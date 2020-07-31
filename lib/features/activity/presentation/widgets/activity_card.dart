import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../domain/entities/activity.dart';
import 'activity_media_info.dart';
import 'activity_modal_bottom_sheet.dart';
import 'background_image_chooser.dart';
import 'custom_bottom_sheet.dart' as customBottomSheet;
import 'platform_icon.dart';
import 'poster_chooser.dart';
import 'progress_bar.dart';
import 'status_poster_overlay.dart';
import 'time_left.dart';

class ActivityCard extends StatefulWidget {
  final ActivityItem activity;

  const ActivityCard(
      {Key key,
      @required this.activity,})
      : super(key: key);

  @override
  _ActivityCardState createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showActivityModalBottomSheet(
          context: context,
          activity: widget.activity,
        );
      },
      child: Card(
        elevation: 2,
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
          child: Container(
            height: 135,
            // Force background of card to not be white
            color: PlexColorPalette.shark,
            child: Stack(
              children: <Widget>[
                //* Background art layer
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Container(
                      width: constraints.maxWidth,
                      child: BackgroundImageChooser(
                        activity: widget.activity,
                      ),
                    );
                  },
                ),
                //* Foreground information layer
                // BackdropFilter for frosted glass effect
                BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 8,
                    sigmaY: 8,
                  ),
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
                                    activity: widget.activity,
                                  ),
                                ),
                                //* Current state poster overlay
                                if (widget.activity.state == 'paused' ||
                                    widget.activity.state == 'buffering')
                                  StatusPosterOverlay(state: widget.activity.state),
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
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          //* Activity info
                                          Expanded(
                                            child: ActivityMediaInfo(
                                              mediaType: widget.activity.mediaType,
                                              title: widget.activity.title,
                                              parentTitle: widget.activity.parentTitle,
                                              grandparentTitle:
                                                  widget.activity.grandparentTitle,
                                              year: widget.activity.year,
                                              mediaIndex: widget.activity.mediaIndex,
                                              parentMediaIndex:
                                                  widget.activity.parentMediaIndex,
                                              live: widget.activity.live,
                                              originallyAvailableAt: widget.activity
                                                  .originallyAvailableAt,
                                            ),
                                          ),
                                          //* Platform icon
                                          Container(
                                            width: 50,
                                            child: PlatformIcon(
                                                widget.activity.platformName),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        //* User name
                                        Text(widget.activity.friendlyName),
                                        //* Time left or Live tv channel
                                        widget.activity.live == 0 &&
                                                widget.activity.duration != null
                                            ? TimeLeft(
                                                duration: widget.activity.duration,
                                                progressPercent:
                                                    widget.activity.progressPercent,
                                              )
                                            : widget.activity.live == 1
                                                ? Text(
                                                    '${widget.activity.channelCallSign} ${widget.activity.channelIdentifier}')
                                                : SizedBox(),
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
                        child: widget.activity.mediaType == 'photo' ||
                                widget.activity.live == 1
                            ? ProgressBar(
                                progress: 100,
                                transcodeProgress: 0,
                              )
                            : ProgressBar(
                                progress: widget.activity.progressPercent,
                                transcodeProgress: widget.activity.transcodeProgress,
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
    );
  }
}

void showActivityModalBottomSheet({
  @required BuildContext context,
  @required ActivityItem activity,
}) {
  customBottomSheet.showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return ActivityModalBottomSheet(
        activity: activity,
      );
    },
  );
}
