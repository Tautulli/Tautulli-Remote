import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/helpers/time_format_helper.dart';
import '../../../../core/widgets/user_icon.dart';
import '../../domain/entities/user_table.dart';
import '../widgets/user_details_history_tab.dart';
import '../widgets/user_details_stats_tab.dart';

class UserDetailsPage extends StatelessWidget {
  final UserTable user;
  final Color backgroundColor;
  final bool maskSensitiveInfo;

  const UserDetailsPage({
    Key key,
    @required this.user,
    @required this.backgroundColor,
    @required this.maskSensitiveInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          //* Background image
          ClipRect(
            child: Container(
              // Height is 185 to provide 10 pixels background to show
              // behind the rounded corners
              height: 195 +
                  10 +
                  MediaQuery.of(context).padding.top -
                  AppBar().preferredSize.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Container(
                    color: backgroundColor,
                  ),
                  if (backgroundColor != null)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                ],
              ),
            ),
          ),
          //* Main body
          Column(
            children: [
              // Empty space for background to show
              SizedBox(
                height: 195 +
                    MediaQuery.of(context).padding.top -
                    AppBar().preferredSize.height,
              ),
              //* Content area
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: PlexColorPalette.shark,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            //* Title section
                            Expanded(
                              child: Container(
                                height: 60,
                                // Make room for the poster
                                padding: const EdgeInsets.only(
                                  left: 107.0 + 8.0,
                                  top: 4,
                                  right: 4,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      maskSensitiveInfo
                                          ? '*Hidden User*'
                                          : user.friendlyName,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'STREAMED ',
                                            ),
                                            TextSpan(
                                              text: user.lastSeen != null
                                                  ? '${TimeFormatHelper.timeAgo(user.lastSeen)}'
                                                  : 'never',
                                              style: TextStyle(
                                                color: PlexColorPalette.gamboge,
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
                        ),
                        Expanded(
                          child: DefaultTabController(
                            length: 2,
                            child: Column(
                              children: [
                                TabBar(
                                  indicatorSize: TabBarIndicatorSize.label,
                                  tabs: [
                                    Tab(
                                      child: Text('Stats'),
                                    ),
                                    Tab(
                                      child: Text('History'),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      UserDetailsStatsTab(
                                        user: user,
                                      ),
                                      UserDetailsHistoryTab(
                                        user: user,
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
                  ),
                ),
              ),
            ],
          ),
          //* Poster
          Positioned(
            top: 155 +
                MediaQuery.of(context).padding.top -
                AppBar().preferredSize.height,
            left: 8,
            child: UserIcon(
              user: user,
              size: 100,
              maskSensitiveInfo: maskSensitiveInfo,
            ),
          ),
        ],
      ),
    );
  }
}
