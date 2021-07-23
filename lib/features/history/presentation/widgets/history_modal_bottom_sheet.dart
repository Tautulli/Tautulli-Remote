import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/strings.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/poster_chooser.dart';
import '../../../../injection_container.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../activity/presentation/bloc/geo_ip_bloc.dart';
import '../../../media/domain/entities/media_item.dart';
import '../../../media/presentation/pages/media_item_page.dart';
import '../../../users/domain/entities/user_table.dart';
import '../../../users/presentation/pages/user_details_page.dart';
import '../../domain/entities/history.dart';
import 'history_info.dart';
import 'history_media_info.dart';

class HistoryModalBottomSheet extends StatelessWidget {
  final History item;
  final Server server;
  final String imageUrlOverride;
  final bool maskSensitiveInfo;
  final bool disableMediaButton;
  final bool disableUserButton;
  final bool disableStreamInfoButton;

  const HistoryModalBottomSheet({
    Key key,
    @required this.item,
    @required this.server,
    this.imageUrlOverride,
    this.maskSensitiveInfo = false,
    this.disableMediaButton = false,
    this.disableUserButton = false,
    this.disableStreamInfoButton = false,
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
                    borderRadius: const BorderRadius.only(
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
                                  isNotEmpty(imageUrlOverride)
                                      ? imageUrlOverride
                                      : item.posterUrl,
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
                                      server: server,
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
                  padding: const EdgeInsets.only(
                    left: 4,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Stack(
                      children: <Widget>[
                        PosterChooser(
                          item: isNotEmpty(imageUrlOverride)
                              ? item.copyWith(posterUrl: imageUrlOverride)
                              : item,
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
              padding: const EdgeInsets.symmetric(vertical: 15),
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
                // if (!disableStreamInfoButton)
                //   Expanded(
                //     child: Padding(
                //       padding: const EdgeInsets.only(
                //         left: 8,
                //         right: 4,
                //       ),
                //       child: ElevatedButton(
                //         onPressed: () {},
                //         style: ElevatedButton.styleFrom(
                //           primary: PlexColorPalette.river_bed,
                //         ),
                //         child: Text(
                //           'Stream Info',
                //           style: TextStyle(
                //             color: TautulliColorPalette.not_white,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                if (!disableUserButton)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 4,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          UserTable user = UserTable(
                            userId: item.userId,
                            friendlyName: item.friendlyName,
                          );

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UserDetailsPage(
                                user: user,
                                forceGetUser: true,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: PlexColorPalette.gamboge,
                        ),
                        child: const Text(
                          LocaleKeys.button_view_user,
                          style: TextStyle(
                            color: TautulliColorPalette.not_white,
                          ),
                        ).tr(),
                      ),
                    ),
                  ),
                if (!disableMediaButton)
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
                        child: const Text(
                          LocaleKeys.button_view_media,
                          style: TextStyle(
                            color: TautulliColorPalette.not_white,
                          ),
                        ).tr(),
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
