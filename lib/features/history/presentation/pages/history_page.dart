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
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../users/presentation/bloc/users_list_bloc.dart';
import '../bloc/history_bloc.dart';
import '../widgets/history_details.dart';
import '../widgets/history_error_button.dart';
import '../widgets/history_modal_bottom_sheet.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key key}) : super(key: key);

  static const routeName = '/history';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HistoryBloc>(
          create: (_) => di.sl<HistoryBloc>(),
        ),
        BlocProvider<UsersListBloc>(
          create: (_) => di.sl<UsersListBloc>(),
        ),
      ],
      child: const HistoryPageContent(),
    );
  }
}

class HistoryPageContent extends StatefulWidget {
  const HistoryPageContent({Key key}) : super(key: key);

  @override
  _HistoryPageContentState createState() => _HistoryPageContentState();
}

class _HistoryPageContentState extends State<HistoryPageContent> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  Completer<void> _refreshCompleter;
  SettingsBloc _settingsBloc;
  HistoryBloc _historyBloc;
  UsersListBloc _usersListBloc;
  String _tautulliId;
  int _userId;
  String _mediaType;
  String _transcodeDecision;
  bool _maskSensitiveInfo;
  Map<String, String> headerMap = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _refreshCompleter = Completer<void>();
    _settingsBloc = context.read<SettingsBloc>();
    _historyBloc = context.read<HistoryBloc>();
    _usersListBloc = context.read<UsersListBloc>();

    final historyState = _historyBloc.state;
    final settingsState = _settingsBloc.state;

    if (settingsState is SettingsLoadSuccess) {
      String lastSelectedServer;

      _maskSensitiveInfo = settingsState.maskSensitiveInfo;

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
        setState(() {
          _tautulliId = null;
        });
      }

      if (historyState is HistoryInitial) {
        if (historyState.tautulliId == _tautulliId) {
          _userId = historyState.userId;
        } else {
          _userId = null;
        }
        _mediaType = historyState.mediaType ?? 'all';
        _transcodeDecision = historyState.transcodeDecision ?? 'all';
      }

      _usersListBloc.add(
        UsersListFetch(
          tautulliId: _tautulliId,
          settingsBloc: _settingsBloc,
        ),
      );

      _historyBloc.add(
        HistoryFetch(
          tautulliId: _tautulliId,
          userId: _userId,
          mediaType: _mediaType,
          transcodeDecision: _transcodeDecision,
          settingsBloc: _settingsBloc,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InnerDrawerScaffold(
      title: Text(
        LocaleKeys.history_page_title.tr(),
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
                            _userId = null;
                            headerMap = newHeaderMap;
                          });
                          _settingsBloc.add(
                            SettingsUpdateLastSelectedServer(
                              tautulliId: _tautulliId,
                            ),
                          );
                          _historyBloc.add(
                            HistoryFilter(
                              tautulliId: value,
                              mediaType: _mediaType,
                              transcodeDecision: _transcodeDecision,
                            ),
                          );
                          _usersListBloc.add(
                            UsersListFetch(
                              tautulliId: _tautulliId,
                              settingsBloc: _settingsBloc,
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
          BlocConsumer<HistoryBloc, HistoryState>(
            listener: (context, state) {
              if (state is HistorySuccess) {
                _refreshCompleter?.complete();
                _refreshCompleter = Completer();
              }
            },
            builder: (context, state) {
              if (state is HistorySuccess) {
                final SettingsLoadSuccess settingsState = _settingsBloc.state;
                final server = settingsState.serverList.firstWhere(
                  (server) => server.tautulliId == _tautulliId,
                );

                if (state.list.isNotEmpty) {
                  return InheritedHeaders(
                    headerMap: headerMap,
                    child: Expanded(
                      child: RefreshIndicator(
                        color: Theme.of(context).accentColor,
                        onRefresh: () {
                          _historyBloc.add(
                            HistoryFilter(
                              tautulliId: _tautulliId,
                              userId: _userId,
                              mediaType: _mediaType,
                              transcodeDecision: _transcodeDecision,
                            ),
                          );
                          return _refreshCompleter.future;
                        },
                        child: Scrollbar(
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return index >= state.list.length
                                  ? BottomLoader()
                                  : GestureDetector(
                                      onTap: () {
                                        return showModalBottomSheet(
                                          context: context,
                                          barrierColor: Colors.black87,
                                          backgroundColor: Colors.transparent,
                                          isScrollControlled: true,
                                          builder: (context) => BlocBuilder<
                                              SettingsBloc, SettingsState>(
                                            builder: (context, settingsState) {
                                              return HistoryModalBottomSheet(
                                                item: state.list[index],
                                                server: server,
                                                maskSensitiveInfo: settingsState
                                                        is SettingsLoadSuccess
                                                    ? settingsState
                                                        .maskSensitiveInfo
                                                    : false,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: PosterCard(
                                        item: state.list[index],
                                        details: HistoryDetails(
                                          historyItem: state.list[index],
                                          server: server,
                                          maskSensitiveInfo: _maskSensitiveInfo,
                                        ),
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
                      child: Text(
                        _mediaType != null || _transcodeDecision != null
                            ? LocaleKeys.history_filter_empty
                            : LocaleKeys.history_empty,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ).tr(),
                    ),
                  );
                }
              }
              if (state is HistoryFailure) {
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
                        HistoryErrorButton(
                          completer: _refreshCompleter,
                          failure: state.failure,
                          historyEvent: HistoryFilter(
                            tautulliId: _tautulliId,
                            userId: _userId,
                            mediaType: _mediaType,
                            transcodeDecision: _transcodeDecision,
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
          ),
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
      _historyBloc.add(
        HistoryFetch(
          tautulliId: _tautulliId,
          userId: _userId,
          mediaType: _mediaType,
          transcodeDecision: _transcodeDecision,
          settingsBloc: _settingsBloc,
        ),
      );
    }
  }

  List<Widget> _appBarActions() {
    ValueNotifier<String> _selectedMediaType = ValueNotifier(_mediaType);
    ValueNotifier<String> _selectedTranscodeType =
        ValueNotifier(_transcodeDecision);

    return [
      //* Users dropdown
      BlocBuilder<UsersListBloc, UsersListState>(
        builder: (context, state) {
          if (state is UsersListSuccess) {
            return PopupMenuButton(
              tooltip: LocaleKeys.general_filter_users.tr(),
              icon: FaIcon(
                FontAwesomeIcons.userAlt,
                size: 20,
                color: _userId != null
                    ? Theme.of(context).accentColor
                    : TautulliColorPalette.not_white,
              ),
              onSelected: (value) {
                setState(() {
                  if (value == -1) {
                    _userId = null;
                  } else {
                    _userId = value;
                  }
                  _historyBloc.add(
                    HistoryFilter(
                      tautulliId: _tautulliId,
                      userId: _userId,
                      mediaType: _mediaType,
                      transcodeDecision: _transcodeDecision,
                    ),
                  );
                });
              },
              itemBuilder: (context) {
                return state.usersList
                    .map(
                      (user) => PopupMenuItem(
                        child: Text(
                          _maskSensitiveInfo
                              ? '*${LocaleKeys.masked_info_user.tr()}*'
                              : user.friendlyName,
                          style: TextStyle(
                            color: _userId == user.userId
                                ? Theme.of(context).accentColor
                                : TautulliColorPalette.not_white,
                          ),
                        ),
                        value: user.userId,
                      ),
                    )
                    .toList();
              },
            );
          }
          if (state is UsersListInProgress) {
            return Center(
              child: Stack(
                children: [
                  IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.userAlt,
                      size: 20,
                    ),
                    color: Theme.of(context).disabledColor,
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: PlexColorPalette.shark,
                          content: const Text(
                            LocaleKeys.general_filter_users_loading,
                          ).tr(),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    right: 5,
                    top: 25,
                    child: SizedBox(
                      height: 13,
                      width: 13,
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return IconButton(
            icon: const FaIcon(FontAwesomeIcons.userAlt),
            color: Theme.of(context).disabledColor,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: PlexColorPalette.shark,
                  content: const Text(
                    LocaleKeys.general_filter_users_failed,
                  ).tr(),
                ),
              );
            },
          );
        },
      ),
      //* Filter dropdown
      PopupMenuButton(
        icon: FaIcon(
          FontAwesomeIcons.filter,
          size: 20,
          color: _mediaType != 'all' || _transcodeDecision != 'all'
              ? Theme.of(context).accentColor
              : TautulliColorPalette.not_white,
        ),
        tooltip: LocaleKeys.general_filter_history.tr(),
        itemBuilder: (context) {
          List mediaTypes = [
            'all',
            'movie',
            'episode',
            'track',
            'live',
          ];
          List transcodeTypes = [
            'all',
            'direct play',
            'copy',
            'transcode',
          ];
          return List.generate(
            10,
            (index) {
              if (index < 5 || index > 5) {
                return PopupMenuItem(
                  value:
                      index < 5 ? mediaTypes[index] : transcodeTypes[index - 6],
                  child: AnimatedBuilder(
                    child: Text(index < 5
                        ? mediaTypes[index]
                        : transcodeTypes[index - 6]),
                    animation:
                        index < 5 ? _selectedMediaType : _selectedTranscodeType,
                    builder: (context, child) {
                      if (index < 5) {
                        return RadioListTile<String>(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          value: mediaTypes[index],
                          groupValue: _selectedMediaType.value,
                          title: Text(
                            _mediaTypeToTitle(mediaTypes[index]),
                          ),
                          onChanged: (value) {
                            if (_mediaType != value) {
                              _selectedMediaType.value = value;
                              setState(() {
                                _mediaType = value;
                              });
                              _historyBloc.add(
                                HistoryFilter(
                                  tautulliId: _tautulliId,
                                  userId: _userId,
                                  mediaType: _mediaType,
                                  transcodeDecision: _transcodeDecision,
                                ),
                              );
                            }
                          },
                        );
                      }
                      return RadioListTile<String>(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 0),
                        value: transcodeTypes[index - 6],
                        groupValue: _selectedTranscodeType.value,
                        title: Text(
                          _transcodeDecisionToTitle(transcodeTypes[index - 6]),
                        ),
                        onChanged: (value) {
                          if (_transcodeDecision != value) {
                            _selectedTranscodeType.value = value;
                            setState(() {
                              _transcodeDecision = value;
                            });
                            _historyBloc.add(
                              HistoryFilter(
                                tautulliId: _tautulliId,
                                userId: _userId,
                                mediaType: _mediaType,
                                transcodeDecision: _transcodeDecision,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                );
              }
              return const PopupMenuDivider();
            },
          );
        },
      ),
    ];
  }
}

String _mediaTypeToTitle(String mediaType) {
  switch (mediaType) {
    case ('all'):
      return LocaleKeys.general_all.tr();
    case ('movie'):
      return LocaleKeys.general_movies.tr();
    case ('episode'):
      return LocaleKeys.general_tv_shows.tr();
    case ('track'):
      return LocaleKeys.general_music.tr();
    case ('other_video'):
      return LocaleKeys.general_videos.tr();
    case ('live'):
      return LocaleKeys.general_live_tv.tr();
    default:
      return '';
  }
}

String _transcodeDecisionToTitle(String decision) {
  switch (decision) {
    case ('all'):
      return LocaleKeys.general_all.tr();
    case ('direct play'):
      return LocaleKeys.media_details_direct_play.tr();
    case ('copy'):
      return LocaleKeys.media_details_direct_stream.tr();
    case ('transcode'):
      return LocaleKeys.media_details_transcode.tr();
    default:
      return '';
  }
}
