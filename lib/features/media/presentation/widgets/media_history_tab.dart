import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/helpers/icon_mapper_helper.dart';
import '../../../../core/helpers/time_format_helper.dart';
import '../../../../core/widgets/bottom_row_loader.dart';
import '../../../../core/widgets/error_message.dart';
import '../../../../injection_container.dart' as di;
import '../../../history/domain/entities/history.dart';
import '../../../history/presentation/bloc/history_individual_bloc.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../users/domain/entities/user_table.dart';

class MediaHistoryTab extends StatelessWidget {
  final int ratingKey;
  final String mediaType;

  const MediaHistoryTab({
    @required this.ratingKey,
    @required this.mediaType,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<HistoryIndividualBloc>(),
      child: MediaHistoryTabContent(
        ratingKey: ratingKey,
        mediaType: mediaType,
      ),
    );
  }
}

class MediaHistoryTabContent extends StatefulWidget {
  final int ratingKey;
  final String mediaType;

  const MediaHistoryTabContent({
    @required this.ratingKey,
    @required this.mediaType,
    Key key,
  }) : super(key: key);

  @override
  _MediaHistoryTabContentState createState() => _MediaHistoryTabContentState();
}

class _MediaHistoryTabContentState extends State<MediaHistoryTabContent> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  SettingsBloc _settingsBloc;
  HistoryIndividualBloc _historyIndividualBloc;
  String _tautulliId;
  bool _maskSensitiveInfo;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _settingsBloc = context.read<SettingsBloc>();
    _historyIndividualBloc = context.read<HistoryIndividualBloc>();

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

      _historyIndividualBloc.add(
        HistoryIndividualFetch(
          tautulliId: _tautulliId,
          ratingKey: ['movie', 'episode', 'track'].contains(widget.mediaType)
              ? widget.ratingKey
              : null,
          parentRatingKey: ['season', 'album'].contains(widget.mediaType)
              ? widget.ratingKey
              : null,
          grandparentRatingKey: ['show', 'artist'].contains(widget.mediaType)
              ? widget.ratingKey
              : null,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryIndividualBloc, HistoryIndividualState>(
      builder: (context, state) {
        if (state is HistoryIndividualFailure) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ErrorMessage(
                failure: state.failure,
                message: state.message,
                suggestion: state.suggestion,
              ),
            ],
          );
        }
        if (state is HistoryIndividualSuccess) {
          return state.list.isEmpty
              ? Center(
                  child: Text('No History'),
                )
              : MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    itemCount: state.hasReachedMax
                        ? state.list.length
                        : state.list.length + 1,
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      final SettingsLoadSuccess settingsState =
                          _settingsBloc.state;
                      final server = settingsState.serverList.firstWhere(
                          (server) => server.tautulliId == _tautulliId);

                      return index >= state.list.length
                          ? BottomRowLoader(
                              index: index,
                            )
                          : _HistoryRow(
                              index: index,
                              server: server,
                              history: state.list[index],
                              mediaType: widget.mediaType,
                              user: state.userTableList.firstWhere(
                                (user) =>
                                    user.userId == state.list[index].userId,
                                orElse: () => null,
                              ),
                              maskSensitiveInfo: _maskSensitiveInfo,
                            );
                    },
                  ),
                );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
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
      _historyIndividualBloc.add(
        HistoryIndividualFetch(
          tautulliId: _tautulliId,
          ratingKey: ['movie', 'episode', 'track'].contains(widget.mediaType)
              ? widget.ratingKey
              : null,
          parentRatingKey: ['season', 'album'].contains(widget.mediaType)
              ? widget.ratingKey
              : null,
          grandparentRatingKey: ['show', 'artist'].contains(widget.mediaType)
              ? widget.ratingKey
              : null,
        ),
      );
    }
  }
}

class _HistoryRow extends StatelessWidget {
  final int index;
  final Server server;
  final History history;
  final UserTable user;
  final String mediaType;
  final bool maskSensitiveInfo;

  const _HistoryRow({
    @required this.index,
    @required this.server,
    @required this.history,
    this.user,
    @required this.mediaType,
    @required this.maskSensitiveInfo,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool hasNetworkImage =
        user != null && user.userThumb.startsWith('http');

    return Container(
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.black26 : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 8.0,
        ),
        child: Row(
          children: [
            // User image
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: hasNetworkImage && !maskSensitiveInfo
                      ? NetworkImage(user.userThumb)
                      : AssetImage('assets/images/default_profile.png'),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(50.0),
                ),
                border: Border.all(
                  color: hasNetworkImage && !maskSensitiveInfo
                      ? Colors.transparent
                      : Color.fromRGBO(69, 69, 69, 1),
                  width: 1,
                ),
              ),
            ),
            // History details
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(maskSensitiveInfo
                              ? '*Hidden User*'
                              : history.friendlyName),
                          if (['show', 'season', 'artist', 'album']
                              .contains(mediaType))
                            Text(
                              history.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          if (mediaType == 'show')
                            Text(
                                'S${history.parentMediaIndex} • E${history.mediaIndex}'),
                          if (mediaType == 'artist') Text(history.parentTitle),
                          if (mediaType == 'season')
                            Text('Episode ${history.mediaIndex}'),
                          Text(
                            TimeFormatHelper.cleanDateTime(
                              history.stopped,
                              dateFormat: server.dateFormat,
                              timeFormat: server.timeFormat,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Watched percent icon
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: IconMapperHelper.mapWatchedStatusToIcon(
                      history.watchedStatus,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
