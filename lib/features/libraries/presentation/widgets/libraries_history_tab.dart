import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/widgets/bottom_loader.dart';
import '../../../../core/widgets/error_message.dart';
import '../../../../core/widgets/poster_card.dart';
import '../../../../injection_container.dart' as di;
import '../../../history/presentation/bloc/history_libraries_bloc.dart';
import '../../../history/presentation/widgets/history_details.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';

class LibrariesHistoryTab extends StatelessWidget {
  final int sectionId;

  const LibrariesHistoryTab({
    @required this.sectionId,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<HistoryLibrariesBloc>(),
      child: _LibrariesHistoryTabContent(
        sectionId: sectionId,
      ),
    );
  }
}

class _LibrariesHistoryTabContent extends StatefulWidget {
  final int sectionId;

  _LibrariesHistoryTabContent({
    @required this.sectionId,
    Key key,
  }) : super(key: key);

  @override
  __LibrariesHistoryTabContentState createState() =>
      __LibrariesHistoryTabContentState();
}

class __LibrariesHistoryTabContentState
    extends State<_LibrariesHistoryTabContent> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  SettingsBloc _settingsBloc;
  HistoryLibrariesBloc _historyLibrariesBloc;
  String _tautulliId;
  bool _maskSensitiveInfo;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _settingsBloc = context.read<SettingsBloc>();
    _historyLibrariesBloc = context.read<HistoryLibrariesBloc>();

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

      _historyLibrariesBloc.add(
        HistoryLibrariesFetch(
          tautulliId: _tautulliId,
          sectionId: widget.sectionId,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryLibrariesBloc, HistoryLibrariesState>(
      builder: (context, state) {
        if (state is HistoryLibrariesFailure) {
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
        if (state is HistoryLibrariesSuccess) {
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

                      return index >= state.list.length
                          ? BottomLoader()
                          : PosterCard(
                              item: state.list[index],
                              details: HistoryDetails(
                                historyItem: state.list[index],
                                server: settingsState.serverList.firstWhere(
                                  (server) => server.tautulliId == _tautulliId,
                                ),
                                maskSensitiveInfo: _maskSensitiveInfo,
                              ),
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
      _historyLibrariesBloc.add(
        HistoryLibrariesFetch(
          tautulliId: _tautulliId,
          sectionId: widget.sectionId,
        ),
      );
    }
  }
}