import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../domain/entities/activity.dart';
import 'activity_media_details.dart';
import 'activity_media_info.dart';
import 'background_image_chooser.dart';
import 'poster_chooser.dart';
import 'progress_bar.dart';
import 'status_poster_overlay.dart';
import 'time_total.dart';

class ActivityModalBottomSheet extends StatelessWidget {
  final ActivityItem activity;

  const ActivityModalBottomSheet({
    Key key,
    @required this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight * 0.70,
          child: Stack(
            children: <Widget>[
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Column(
                    children: <Widget>[
                      // Creates a transparent area for the poster to hover over
                      // Allows for that area to be tapped to dismiss the modal bottom sheet
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: constraints.maxHeight * 0.02,
                          width: constraints.maxWidth,
                          color: Colors.transparent,
                        ),
                      ),
                      // The main area of the modal bottom sheet
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: Container(
                          // height: constraints.maxHeight * 0.88,
                          height: constraints.maxHeight * 0.98,
                          width: constraints.maxWidth,
                          // color: PlexColorPalette.river_bed,
                          child: Column(
                            children: <Widget>[
                              // Activity art section
                              Container(
                                height: 130,
                                width: constraints.maxWidth,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      width: constraints.maxWidth,
                                      child: BackgroundImageChooser(
                                        activity: activity,
                                      ),
                                    ),
                                    BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 8,
                                        sigmaY: 8,
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
                                                mediaType: activity.mediaType,
                                                title: activity.title,
                                                parentTitle:
                                                    activity.parentTitle,
                                                grandparentTitle:
                                                    activity.grandparentTitle,
                                                year: activity.year,
                                                mediaIndex: activity.mediaIndex,
                                                parentMediaIndex:
                                                    activity.parentMediaIndex,
                                                live: activity.live,
                                                originallyAvailableAt: activity
                                                    .originallyAvailableAt,
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
                                                Text(activity.friendlyName),
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
                                                            '${activity.channelCallSign} ${activity.channelIdentifier}')
                                                        : SizedBox(),
                                              ],
                                            ),
                                          ),
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
                              Expanded(
                                child: Container(
                                  width: constraints.maxWidth,
                                  color: PlexColorPalette.river_bed,
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        child: ActivityMediaDetails(
                                          constraints: constraints,
                                          activity: activity,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              // Poster
              Container(
                height: 130,
                padding: EdgeInsets.only(
                  left: 4,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: <Widget>[
                      PosterChooser(
                        activity: activity,
                      ),
                      if (activity.state == 'paused' ||
                          activity.state == 'buffering')
                        StatusPosterOverlay(state: activity.state),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
