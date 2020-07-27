import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/helpers/tautulli_api_url_helper.dart';
import '../../domain/entities/activity.dart';
import '../../domain/entities/geo_ip.dart';
import 'activity_media_details.dart';
import 'activity_media_info.dart';
import 'background_image_chooser.dart';
import 'poster_chooser.dart';
import 'progress_bar.dart';
import 'status_poster_overlay.dart';
import 'time_total.dart';

class ActivityModalBottomSheet extends StatelessWidget {
  final TautulliApiUrls tautulliApiUrls;
  final ActivityItem activity;
  final GeoIpItem geoIp;
  final ServerModel server;

  const ActivityModalBottomSheet({
    Key key,
    @required this.tautulliApiUrls,
    @required this.activity,
    @required this.geoIp,
    @required this.server,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
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
                      // height: constraints.maxHeight * 0.12,
                      height: constraints.maxHeight * 0.05,
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
                      height: constraints.maxHeight * 0.95,
                      width: constraints.maxWidth,
                      // color: PlexColorPalette.river_bed,
                      child: Column(
                        children: <Widget>[
                          // Activity art section
                          Container(
                            height: 110,
                            width: constraints.maxWidth,
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  width: constraints.maxWidth,
                                  child: BackgroundImageChooser(
                                    tautulliApiUrls: tautulliApiUrls,
                                    activity: activity,
                                    server: server,
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
                                            left: 92,
                                            right: 4,
                                          ),
                                          child: ActivityMediaInfo(
                                            mediaType: activity.mediaType,
                                            title: activity.title,
                                            parentTitle: activity.parentTitle,
                                            grandparentTitle:
                                                activity.grandparentTitle,
                                            year: activity.year,
                                            mediaIndex: activity.mediaIndex,
                                            parentMediaIndex:
                                                activity.parentMediaIndex,
                                            live: activity.live,
                                            originallyAvailableAt:
                                                activity.originallyAvailableAt,
                                          ),
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
                                              transcodeProgress:
                                                  activity.transcodeProgress,
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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 4,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        //* User name
                                        Text(activity.friendlyName),
                                        //* Time left or Live tv channel
                                        activity.live == 0 &&
                                                activity.duration != null
                                            ? TimeTotal(
                                                viewOffset: activity.viewOffset,
                                                duration: activity.duration,
                                              )
                                            : activity.live == 1
                                                ? Text(
                                                    '${activity.channelCallSign} ${activity.channelIdentifier}')
                                                : SizedBox(),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: ActivityMediaDetails(
                                      constraints: constraints,
                                      activity: activity,
                                      geoIp: geoIp,
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
                    tautulliApiUrls: tautulliApiUrls,
                    activity: activity,
                    server: server,
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
  }
}
