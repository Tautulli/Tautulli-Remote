import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _settingsBloc = context.bloc<SettingsBloc>();
    _recentlyAddedBloc = context.bloc<RecentlyAddedBloc>();

    final state = _settingsBloc.state;

    if (state is SettingsLoadSuccess) {
      setState(() {
        tautulliId = state.serverList[0].tautulliId;
      });
      _recentlyAddedBloc.add(RecentlyAddedFetched(tautulliId: tautulliId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Recently Added'),
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
                            _recentlyAddedBloc.add(
                                RecentlyAddedLoadNewServer(tautulliId: value));
                          });
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
                return Expanded(
                  child: Scrollbar(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return index >= state.list.length
                            ? BottomLoader()
                            : RecentlyAddedCard(recentItem: state.list[index]);
                      },
                      itemCount: state.hasReachedMax
                          ? state.list.length
                          : state.list.length + 1,
                      controller: _scrollController,
                    ),
                  ),
                );
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
      print('triggered');
      _recentlyAddedBloc.add(RecentlyAddedFetched(tautulliId: tautulliId));
    }
  }
}
