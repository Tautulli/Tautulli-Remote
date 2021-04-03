import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/helpers/time_format_helper.dart';
import '../../../../core/widgets/user_icon.dart';
import '../../../../injection_container.dart' as di;
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/user_table.dart';
import '../bloc/user_bloc.dart';
import '../widgets/user_details_history_tab.dart';
import '../widgets/user_details_stats_tab.dart';

class UserDetailsPage extends StatelessWidget {
  final UserTable user;
  final Color backgroundColor;
  final Key heroTag;
  final bool forceGetUser;
  final String tautulliIdOverride;

  const UserDetailsPage({
    Key key,
    @required this.user,
    this.backgroundColor,
    this.heroTag,
    this.forceGetUser = false,
    this.tautulliIdOverride,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<UserBloc>(),
      child: UserDetailsPageContent(
        user: user,
        backgroundColor: backgroundColor,
        heroTag: heroTag,
        forceGetUser: forceGetUser,
        tautulliIdOverride: tautulliIdOverride,
      ),
    );
  }
}

class UserDetailsPageContent extends StatefulWidget {
  final UserTable user;
  final Color backgroundColor;
  final Key heroTag;
  final bool forceGetUser;
  final String tautulliIdOverride;

  const UserDetailsPageContent({
    Key key,
    @required this.user,
    @required this.backgroundColor,
    @required this.heroTag,
    @required this.forceGetUser,
    @required this.tautulliIdOverride,
  }) : super(key: key);

  @override
  _UserDetailsPageContentState createState() => _UserDetailsPageContentState();
}

class _UserDetailsPageContentState extends State<UserDetailsPageContent> {
  SettingsBloc _settingsBloc;
  UserBloc _userBloc;
  String _tautulliId;
  bool _maskSensitiveInfo;

  @override
  void initState() {
    super.initState();
    _settingsBloc = context.read<SettingsBloc>();
    _userBloc = context.read<UserBloc>();

    final settingsState = _settingsBloc.state;

    if (settingsState is SettingsLoadSuccess) {
      String lastSelectedServer;

      _maskSensitiveInfo = settingsState.maskSensitiveInfo;

      if (settingsState.lastSelectedServer != null) {
        for (Server server in settingsState.serverList) {
          if (server.tautulliId == settingsState.lastSelectedServer) {
            lastSelectedServer = settingsState.lastSelectedServer;
            break;
          }
        }
      }

      if (lastSelectedServer != null) {
        setState(() {
          _tautulliId = lastSelectedServer;
        });
      } else if (settingsState.serverList.length > 0) {
        setState(() {
          _tautulliId = settingsState.serverList[0].tautulliId;
        });
      } else {
        _tautulliId = null;
      }

      if (widget.forceGetUser) {
        _userBloc.add(
          UserFetch(
            tautulliId: widget.tautulliIdOverride ?? _tautulliId,
            userId: widget.user.userId,
            settingsBloc: _settingsBloc,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasNetworkImage = widget.user.userThumb != null
        ? widget.user.userThumb.startsWith('http')
        : false;
    Future getColorFuture = _getColor(hasNetworkImage, widget.user.userThumb);

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
                  widget.backgroundColor != null
                      ? Container(
                          color: widget.backgroundColor,
                        )
                      : widget.backgroundColor == null && hasNetworkImage
                          ? FutureBuilder(
                              future: getColorFuture,
                              builder: (context, snapshot) {
                                bool hasCustomColor =
                                    snapshot.connectionState ==
                                            ConnectionState.done &&
                                        snapshot.data['color'] != null;

                                return Container(
                                  color: hasCustomColor
                                      ? snapshot.data['color']
                                      : null,
                                );
                              },
                            )
                          : BlocBuilder<UserBloc, UserState>(
                              builder: (context, state) {
                                if (state is UserSuccess) {
                                  bool hasNetworkImage = state.user.userThumb !=
                                          null
                                      ? state.user.userThumb.startsWith('http')
                                      : false;

                                  if (hasNetworkImage) {
                                    return FutureBuilder(
                                      future: _getColor(
                                        hasNetworkImage,
                                        state.user.userThumb,
                                      ),
                                      builder: (context, snapshot) {
                                        bool hasCustomColor =
                                            snapshot.connectionState ==
                                                    ConnectionState.done &&
                                                snapshot.data['color'] != null;

                                        return Container(
                                          color: hasCustomColor
                                              ? snapshot.data['color']
                                              : null,
                                        );
                                      },
                                    );
                                  }
                                }
                                return SizedBox(height: 0, width: 0);
                              },
                            ),
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
                                      _maskSensitiveInfo
                                          ? '*Hidden User*'
                                          : widget.user.friendlyName,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: !widget.forceGetUser
                                          ? RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: 'STREAMED ',
                                                  ),
                                                  TextSpan(
                                                    text: widget.user
                                                                .lastSeen !=
                                                            null
                                                        ? '${TimeFormatHelper.timeAgo(widget.user.lastSeen)}'
                                                        : 'never',
                                                    style: TextStyle(
                                                      color: PlexColorPalette
                                                          .gamboge,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : BlocBuilder<UserBloc, UserState>(
                                              builder: (context, state) {
                                                if (state is UserSuccess) {
                                                  if (state.user.lastSeen !=
                                                      null) {
                                                    return RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: 'STREAMED ',
                                                          ),
                                                          TextSpan(
                                                            text: state.user
                                                                        .lastSeen !=
                                                                    null
                                                                ? '${TimeFormatHelper.timeAgo(state.user.lastSeen)}'
                                                                : 'never',
                                                            style: TextStyle(
                                                              color:
                                                                  PlexColorPalette
                                                                      .gamboge,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                }
                                                return SizedBox(
                                                    height: 0, width: 0);
                                              },
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
                                        user: widget.user,
                                      ),
                                      UserDetailsHistoryTab(
                                        user: widget.user,
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
          //* UserIcon
          Positioned(
            top: 155 +
                MediaQuery.of(context).padding.top -
                AppBar().preferredSize.height,
            left: 8,
            child: !widget.forceGetUser || widget.user.userThumb != null
                ? Hero(
                    tag: widget.heroTag ?? UniqueKey(),
                    child: UserIcon(
                      user: widget.user,
                      size: 100,
                      maskSensitiveInfo: _maskSensitiveInfo,
                    ),
                  )
                : BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      if (state is UserSuccess) {
                        return Hero(
                          tag: widget.heroTag ?? UniqueKey(),
                          child: UserIcon(
                            user: state.user,
                            size: 100,
                            maskSensitiveInfo: _maskSensitiveInfo,
                          ),
                        );
                      }
                      return SizedBox(height: 0, width: 0);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

Future<Map<String, dynamic>> _getColor(bool hasUrl, String url) async {
  if (hasUrl) {
    NetworkImage userProfileImage = NetworkImage(url);
    final palette = await PaletteGenerator.fromImageProvider(
      NetworkImage(url),
      maximumColorCount: 1,
    );
    return {
      'image': userProfileImage,
      'color': palette.colors.isNotEmpty ? palette.dominantColor.color : null,
    };
  }
  return {
    'image': null,
    'color': PlexColorPalette.shark,
  };
}
