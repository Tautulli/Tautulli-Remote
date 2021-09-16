// @dart=2.9

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/database/data/models/custom_header_model.dart';
import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/bottom_loader.dart';
import '../../../../core/widgets/error_message.dart';
import '../../../../core/widgets/inherited_headers.dart';
import '../../../../core/widgets/inner_drawer_scaffold.dart';
import '../../../../core/widgets/poster_card.dart';
import '../../../../core/widgets/server_header.dart';
import '../../../../injection_container.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../media/domain/entities/media_item.dart';
import '../../../media/presentation/pages/media_item_page.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../bloc/recently_added_bloc.dart';
import '../widgets/recently_added_details.dart';
import '../widgets/recently_added_error_button.dart';

class RecentlyAddedPage extends StatelessWidget {
  const RecentlyAddedPage({Key key}) : super(key: key);

  static const routeName = '/recent';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<RecentlyAddedBloc>(),
      child: const RecentlyAddedPageContent(),
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
  final _scrollThreshold = 200.0;
  Completer<void> _refreshCompleter;
  SettingsBloc _settingsBloc;
  RecentlyAddedBloc _recentlyAddedBloc;
  String _tautulliId;
  String _mediaType = 'all';
  Map<String, String> headerMap = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _refreshCompleter = Completer<void>();
    _settingsBloc = context.read<SettingsBloc>();
    _recentlyAddedBloc = context.read<RecentlyAddedBloc>();

    final recentlyAddedState = _recentlyAddedBloc.state;
    final settingsState = _settingsBloc.state;

    if (settingsState is SettingsLoadSuccess) {
      String lastSelectedServer;

      if (settingsState.lastSelectedServer != null) {
        for (Server server in settingsState.serverList) {
          if (server.tautulliId == settingsState.lastSelectedServer) {
            lastSelectedServer = settingsState.lastSelectedServer;

            for (CustomHeaderModel header in server.customHeaders) {
              headerMap[header.key] = header.value;
            }

            break;
          }
        }
      }

      if (lastSelectedServer != null) {
        setState(() {
          _tautulliId = lastSelectedServer;
        });
      } else if (settingsState.serverList.isNotEmpty) {
        setState(() {
          _tautulliId = settingsState.serverList[0].tautulliId;
          for (CustomHeaderModel header
              in settingsState.serverList[0].customHeaders) {
            headerMap[header.key] = header.value;
          }
        });
      } else {
        _tautulliId = null;
      }

      if (recentlyAddedState is RecentlyAddedInitial) {
        _mediaType = recentlyAddedState.mediaType ?? 'all';
      }

      _recentlyAddedBloc.add(RecentlyAddedFetched(
        tautulliId: _tautulliId,
        mediaType: _mediaType,
        settingsBloc: _settingsBloc,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return InnerDrawerScaffold(
      title: Text(
        LocaleKeys.recently_added_page_title.tr(),
      ),
      actions: _appBarActions(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              if (state is SettingsLoadSuccess) {
                if (state.serverList.length > 1) {
                  return DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: _tautulliId,
                      style: TextStyle(color: Theme.of(context).accentColor),
                      items: state.serverList.map((server) {
                        return DropdownMenuItem(
                          child: ServerHeader(serverName: server.plexName),
                          value: server.tautulliId,
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != _tautulliId) {
                          final server = state.serverList.firstWhere(
                              (server) => server.tautulliId == value);
                          Map<String, String> newHeaderMap = {};
                          for (CustomHeaderModel header
                              in server.customHeaders) {
                            newHeaderMap[header.key] = header.value;
                          }

                          setState(() {
                            _tautulliId = value;
                            // _mediaType = 'all';
                            headerMap = newHeaderMap;
                          });
                          _settingsBloc.add(
                            SettingsUpdateLastSelectedServer(
                                tautulliId: _tautulliId),
                          );
                          _recentlyAddedBloc.add(
                            RecentlyAddedFilter(
                              tautulliId: value,
                              mediaType: _mediaType,
                            ),
                          );
                        }
                      },
                    ),
                  );
                }
              }
              return Container(height: 0, width: 0);
            },
          ),
          BlocConsumer<RecentlyAddedBloc, RecentlyAddedState>(
            listener: (context, state) {
              if (state is RecentlyAddedSuccess) {
                _refreshCompleter?.complete();
                _refreshCompleter = Completer();
              }
            },
            builder: (context, state) {
              if (state is RecentlyAddedSuccess) {
                if (state.list.isNotEmpty) {
                  return InheritedHeaders(
                    headerMap: headerMap,
                    child: Expanded(
                      child: RefreshIndicator(
                        color: Theme.of(context).accentColor,
                        onRefresh: () {
                          _recentlyAddedBloc.add(
                            RecentlyAddedFilter(
                              tautulliId: _tautulliId,
                              mediaType: _mediaType,
                            ),
                          );
                          return _refreshCompleter.future;
                        },
                        child: Scrollbar(
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              final heroTag = UniqueKey();

                              return index >= state.list.length
                                  ? BottomLoader()
                                  : GestureDetector(
                                      onTap: () {
                                        final recentItem = state.list[index];

                                        MediaItem mediaItem = MediaItem(
                                          grandparentTitle:
                                              recentItem.grandparentTitle,
                                          parentMediaIndex:
                                              recentItem.parentMediaIndex,
                                          mediaIndex: recentItem.mediaIndex,
                                          mediaType: recentItem.mediaType,
                                          parentTitle: recentItem.parentTitle,
                                          posterUrl: recentItem.posterUrl,
                                          ratingKey: recentItem.ratingKey,
                                          title: recentItem.title,
                                          year: recentItem.year,
                                        );

                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => MediaItemPage(
                                              item: mediaItem,
                                              heroTag: heroTag,
                                              enableNavOptions: true,
                                            ),
                                          ),
                                        );
                                      },
                                      child: PosterCard(
                                        heroTag: heroTag,
                                        item: state.list[index],
                                        details: RecentlyAddedDetails(
                                            recentItem: state.list[index]),
                                      ),
                                    );
                            },
                            itemCount: state.hasReachedMax
                                ? state.list.length
                                : state.list.length + 1,
                            controller: _scrollController,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: Center(
                      child: _mediaType == 'all'
                          ? const Text(
                              LocaleKeys.recently_added_empty,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ).tr()
                          : const Text(
                              LocaleKeys.recently_added_empty_filter,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ).tr(
                              args: [_mediaTypeToTitle(_mediaType)],
                            ),
                    ),
                  );
                }
              }
              if (state is RecentlyAddedFailure) {
                return Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: ErrorMessage(
                            failure: state.failure,
                            message: state.message,
                            suggestion: state.suggestion,
                          ),
                        ),
                        RecentlyAddedErrorButton(
                          completer: _refreshCompleter,
                          failure: state.failure,
                          recentlyAddedEvent: RecentlyAddedFilter(
                            tautulliId: _tautulliId,
                            mediaType: _mediaType,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).accentColor,
                  ),
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
      _recentlyAddedBloc.add(
        RecentlyAddedFetched(
          tautulliId: _tautulliId,
          mediaType: _mediaType,
          settingsBloc: _settingsBloc,
        ),
      );
    }
  }

  List<Widget> _appBarActions() {
    return [
      PopupMenuButton(
        icon: FaIcon(
          FontAwesomeIcons.filter,
          size: 20,
          color: _mediaType != 'all'
              ? Theme.of(context).accentColor
              : TautulliColorPalette.not_white,
        ),
        tooltip: LocaleKeys.general_tooltip_filter_media_type.tr(),
        onSelected: (value) {
          if (_mediaType != value) {
            setState(() {
              _mediaType = value;
            });
            _recentlyAddedBloc.add(RecentlyAddedFilter(
              tautulliId: _tautulliId,
              mediaType: _mediaType,
            ));
          }
        },
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              child: Text(
                LocaleKeys.general_all,
                style: TextStyle(
                  color: _mediaType == 'all'
                      ? Theme.of(context).accentColor
                      : TautulliColorPalette.not_white,
                ),
              ).tr(),
              value: 'all',
            ),
            PopupMenuItem(
              child: Text(
                LocaleKeys.general_movies,
                style: TextStyle(
                  color: _mediaType == 'movie'
                      ? Theme.of(context).accentColor
                      : TautulliColorPalette.not_white,
                ),
              ).tr(),
              value: 'movie',
            ),
            PopupMenuItem(
              child: Text(
                LocaleKeys.general_tv_shows,
                style: TextStyle(
                  color: _mediaType == 'show'
                      ? Theme.of(context).accentColor
                      : TautulliColorPalette.not_white,
                ),
              ).tr(),
              value: 'show',
            ),
            PopupMenuItem(
              child: Text(
                LocaleKeys.general_music,
                style: TextStyle(
                  color: _mediaType == 'artist'
                      ? Theme.of(context).accentColor
                      : TautulliColorPalette.not_white,
                ),
              ).tr(),
              value: 'artist',
            ),
            PopupMenuItem(
              child: Text(
                LocaleKeys.general_videos,
                style: TextStyle(
                  color: _mediaType == 'other_video'
                      ? Theme.of(context).accentColor
                      : TautulliColorPalette.not_white,
                ),
              ).tr(),
              value: 'other_video',
            ),
          ];
        },
      )
    ];
  }
}

String _mediaTypeToTitle(String mediaType) {
  switch (mediaType) {
    case ('movie'):
      return LocaleKeys.general_movies.tr();
    case ('show'):
      return LocaleKeys.general_tv_shows.tr();
    case ('artist'):
      return LocaleKeys.general_music.tr();
    case ('other_video'):
      return LocaleKeys.general_videos.tr();
    default:
      return LocaleKeys.general_unknown.tr();
  }
}
