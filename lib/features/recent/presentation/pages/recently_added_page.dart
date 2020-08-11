import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tautulli_remote_tdd/core/helpers/color_palette_helper.dart';

import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/error_message.dart';
import '../../../../core/widgets/server_header.dart';
import '../../../../injection_container.dart' as di;
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../bloc/recently_added_bloc.dart';
import '../widgets/bottom_loader.dart';
import '../widgets/recently_added_card.dart';

class RecentlyAddedPage extends StatelessWidget {
  const RecentlyAddedPage({Key key}) : super(key: key);

  static const routeName = '/recent';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<RecentlyAddedBloc>(),
      child: RecentlyAddedPageContent(),
    );
  }
}

class RecentlyAddedPageContent extends StatefulWidget {
  const RecentlyAddedPageContent({Key key}) : super(key: key);

  @override
  _RecentlyAddedPageContentState createState() =>
      _RecentlyAddedPageContentState();
}

class _RecentlyAddedPageContentState extends State<RecentlyAddedPageContent> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 500.0;
  SettingsBloc _settingsBloc;
  RecentlyAddedBloc _recentlyAddedBloc;
  String tautulliId;
  String _mediaType;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _settingsBloc = context.bloc<SettingsBloc>();
    _recentlyAddedBloc = context.bloc<RecentlyAddedBloc>();
    _mediaType = 'all';

    final state = _settingsBloc.state;

    if (state is SettingsLoadSuccess) {
      setState(() {
        tautulliId = state.serverList[0].tautulliId;
      });
      _recentlyAddedBloc.add(RecentlyAddedFetched(
        tautulliId: tautulliId,
        mediaType: _mediaType,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Recently Added'),
        actions: [
          PopupMenuButton(
            icon: FaIcon(
              FontAwesomeIcons.filter,
              color: _mediaType == 'all'
                  ? TautulliColorPalette.not_white
                  : Theme.of(context).accentColor,
            ),
            onSelected: (value) {
              setState(() {
                _mediaType = value;
              });
              _recentlyAddedBloc.add(RecentlyAddedFilter(
                tautulliId: tautulliId,
                mediaType: _mediaType,
              ));
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text(
                    'All',
                    style: TextStyle(
                      color: _mediaType == 'all'
                          ? Theme.of(context).accentColor
                          : TautulliColorPalette.not_white,
                    ),
                  ),
                  value: 'all',
                ),
                PopupMenuItem(
                  child: Text(
                    'Movies',
                    style: TextStyle(
                      color: _mediaType == 'movie'
                          ? Theme.of(context).accentColor
                          : TautulliColorPalette.not_white,
                    ),
                  ),
                  value: 'movie',
                ),
                PopupMenuItem(
                  child: Text(
                    'TV Shows',
                    style: TextStyle(
                      color: _mediaType == 'show'
                          ? Theme.of(context).accentColor
                          : TautulliColorPalette.not_white,
                    ),
                  ),
                  value: 'show',
                ),
                PopupMenuItem(
                  child: Text(
                    'Music',
                    style: TextStyle(
                      color: _mediaType == 'artist'
                          ? Theme.of(context).accentColor
                          : TautulliColorPalette.not_white,
                    ),
                  ),
                  value: 'artist',
                ),
                PopupMenuItem(
                  child: Text(
                    'Videos',
                    style: TextStyle(
                      color: _mediaType == 'other_video'
                          ? Theme.of(context).accentColor
                          : TautulliColorPalette.not_white,
                    ),
                  ),
                  value: 'other_video',
                ),
              ];
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              if (state is SettingsLoadSuccess) {
                if (state.serverList.length > 1) {
                  return DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: tautulliId,
                      style: TextStyle(color: Theme.of(context).accentColor),
                      items: state.serverList.map((server) {
                        return DropdownMenuItem(
                          child: ServerHeader(serverName: server.plexName),
                          value: server.tautulliId,
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != tautulliId) {
                          setState(() {
                            tautulliId = value;
                            _mediaType = 'all';
                          });
                          _recentlyAddedBloc.add(RecentlyAddedFilter(
                            tautulliId: value,
                            mediaType: _mediaType,
                          ));
                        }
                      },
                    ),
                  );
                }
              }

              return Container(height: 0, width: 0);
            },
          ),
          BlocBuilder<RecentlyAddedBloc, RecentlyAddedState>(
            builder: (context, state) {
              if (state is RecentlyAddedSuccess) {
                if (state.list.length > 0) {
                  return Expanded(
                    child: Scrollbar(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return index >= state.list.length
                              ? BottomLoader()
                              : RecentlyAddedCard(
                                  recentItem: state.list[index]);
                        },
                        itemCount: state.hasReachedMax
                            ? state.list.length
                            : state.list.length + 1,
                        controller: _scrollController,
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: Center(
                      child: _mediaType == 'all'
                          ? Text(
                              'No recently added items.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            )
                          : Text(
                              'No recently added items for ${_mediaTypeToTitle(_mediaType)}.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  );
                }
              }
              if (state is RecentlyAddedFailure) {
                return Expanded(
                  child: ErrorMessage(
                    failure: state.failure,
                    message: state.message,
                    suggestion: state.suggestion,
                  ),
                );
              }
              return Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _recentlyAddedBloc.add(RecentlyAddedFetched(
        tautulliId: tautulliId,
        mediaType: _mediaType,
      ));
    }
  }
}

String _mediaTypeToTitle(String mediaType) {
  switch (mediaType) {
    case ('movie'):
      return 'Movies';
    case ('show'):
      return 'TV Shows';
    case ('artist'):
      return 'Music';
    case ('other_video'):
      return 'Videos';
    default:
      return 'unknown';
  }
}
