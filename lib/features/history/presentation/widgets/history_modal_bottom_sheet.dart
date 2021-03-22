import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/poster_chooser.dart';
import '../../../../injection_container.dart' as di;
import '../../../activity/presentation/bloc/geo_ip_bloc.dart';
import '../../../media/domain/entities/media_item.dart';
import '../../../media/presentation/pages/media_item_page.dart';
import '../../domain/entities/history.dart';
import 'history_info.dart';
import 'history_media_info.dart';

class HistoryModalBottomSheet extends StatelessWidget {
  final History item;
  final Server server;
  final bool maskSensitiveInfo;

  const HistoryModalBottomSheet({
    Key key,
    @required this.item,
    @required this.server,
    this.maskSensitiveInfo = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Creates a transparent area for the poster to hover over
                  // Allows for that area to be tapped to dismiss the modal bottom sheet
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 35,
                      color: Colors.transparent,
                    ),
                  ),
                  //* History art section
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: Container(
                      height: 100,
                      child: Stack(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Positioned.fill(
                                child: Image.network(
                                  item.posterUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned.fill(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 25,
                              sigmaY: 25,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 4,
                                      left: 98,
                                      bottom: 4,
                                      right: 4,
                                    ),
                                    child: HistoryMediaInfo(
                                      history: item,
                                    ),
                                  ),
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
                bottom: 4,
                child: Container(
                  height: 130,
                  padding: EdgeInsets.only(
                    left: 4,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Stack(
                      children: <Widget>[
                        PosterChooser(
                          item: item,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              color: Theme.of(context).backgroundColor,
              child: BlocProvider<GeoIpBloc>(
                create: (_) => di.sl<GeoIpBloc>(),
                child: HistoryInfo(
                  item: item,
                  server: server,
                  maskSensitiveInfo: maskSensitiveInfo,
                ),
              ),
            ),
          ),
          Container(
            color: Theme.of(context).backgroundColor,
            child: Row(
              children: [
                // Expanded(
                //   child: Padding(
                //     padding: const EdgeInsets.only(
                //       left: 8,
                //       right: 4,
                //     ),
                //     child: ElevatedButton(
                //       onPressed: () {},
                //       style: ElevatedButton.styleFrom(
                //         primary: PlexColorPalette.river_bed,
                //       ),
                //       child: Text(
                //         'Stream Info',
                //         style: TextStyle(
                //           color: TautulliColorPalette.not_white,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // Expanded(
                //   child: Padding(
                //     padding: const EdgeInsets.only(
                //       left: 8,
                //       right: 4,
                //     ),
                //     child: ElevatedButton(
                //       onPressed: () {},
                //       style: ElevatedButton.styleFrom(
                //         primary: PlexColorPalette.gamboge,
                //       ),
                //       child: Text(
                //         'View User',
                //         style: TextStyle(
                //           color: TautulliColorPalette.not_white,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 4,
                      right: 8,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        MediaItem mediaItem = MediaItem(
                          grandparentTitle: item.grandparentTitle,
                          parentMediaIndex: item.parentMediaIndex,
                          mediaIndex: item.mediaIndex,
                          mediaType: item.mediaType,
                          parentTitle: item.parentTitle,
                          posterUrl: item.posterUrl,
                          ratingKey: item.ratingKey,
                          title: item.title,
                          year: item.year,
                        );

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MediaItemPage(
                              item: mediaItem,
                              enableNavOptions: true,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: PlexColorPalette.curious_blue,
                      ),
                      child: Text(
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
        ],
      ),
    );
  }
}
