import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tautulli_remote_tdd/features/activity/presentation/widgets/background_image_chooser.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/helpers/tautulli_api_url_helper.dart';
import '../../../settings/domain/entities/settings.dart';
import '../../domain/entities/activity.dart';
import '../../domain/entities/geo_ip.dart';
import 'activity_media_info.dart';
import 'activity_modal_bottom_sheet.dart';
import 'custom_bottom_sheet.dart' as customBottomSheet;
import 'platform_icon.dart';
import 'poster_chooser.dart';
import 'progress_bar.dart';
import 'status_poster_overlay.dart';
import 'time_left.dart';

class ActivityCard extends StatelessWidget {
  final ActivityItem activity;
  final GeoIpItem geoIp;
  final Settings settings;
  final TautulliApiUrls tautulliApiUrls;

  const ActivityCard(
      {Key key,
      @required this.activity,
      @required this.geoIp,
      @required this.settings,
      @required this.tautulliApiUrls})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showActivityModalBottomSheet(
          context: context,
          tautulliApiUrls: tautulliApiUrls,
          activity: activity,
          geoIp: geoIp,
          settings: settings,
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
                        activity: activity,
                        settings: settings,
                        tautulliApiUrls: tautulliApiUrls,
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
                        child: Row(
                          children: <Widget>[
                            //* Poster section
                            Stack(
                              children: <Widget>[
                                //* Poster
                                Container(
                                  height: 130,
                                  child: PosterChooser(
                                    tautulliApiUrls: tautulliApiUrls,
                                    activity: activity,
                                    settings: settings,
                                  ),
                                ),
                                //* Current state poster overlay
                                if (activity.state == 'paused' ||
                                    activity.state == 'buffering')
                                  StatusPosterOverlay(state: activity.state),
                              ],
                            ),
                            //* Info section
                            Expanded(
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
                                        //* Platform icon
                                        Container(
                                          padding: EdgeInsets.only(
                                            right: 3,
                                            top: 3,
                                          ),
                                          width: 50,
                                          child: PlatformIcon(
                                              activity.platformName),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 3,
                                      right: 3,
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
                                            ? TimeLeft(
                                                duration: activity.duration,
                                                progressPercent:
                                                    activity.progressPercent,
                                              )
                                            : activity.live == 1
                                                ? Text(
                                                    '${activity.channelCallSign} ${activity.channelIdentifier}')
                                                : SizedBox(),
                                      ],
                                    ),
                                  ),
                                ],
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
                                transcodeProgress: activity.transcodeProgress,
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
  @required TautulliApiUrls tautulliApiUrls,
  @required ActivityItem activity,
  @required GeoIpItem geoIp,
  @required Settings settings,
}) {
  customBottomSheet.showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return ActivityModalBottomSheet(
        tautulliApiUrls: tautulliApiUrls,
        activity: activity,
        geoIp: geoIp,
        settings: settings,
      );
    },
  );
}
