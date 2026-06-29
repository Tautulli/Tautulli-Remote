import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/pages/material/material_style_status_page.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/types/media_type.dart';
import '../../../../../core/utilities/cast.dart';
import '../../../../../core/widgets/material/material_style_bottom_loader.dart';
import '../../../../../core/widgets/material/material_style_page_body.dart';
import '../../../../../core/widgets/material/material_style_scaffold_with_inner_drawer.dart';
import '../../../../../core/widgets/material/material_style_refresh_indicator.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../bloc/recently_added_bloc.dart';
import '../../widgets/material/bottom_sheets/material_style_recently_added_filter_bottom_sheet.dart';
import '../../widgets/material/material_style_recently_added_card.dart';

class MaterialStyleRecentlyAddedPage extends StatelessWidget {
  const MaterialStyleRecentlyAddedPage({super.key});

  static const routeName = '/recent';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final refreshOnLoad = args?['refreshOnLoad'] as bool? ?? false;

    return BlocProvider(
      create: (context) => di.sl<RecentlyAddedBloc>(param1: context.read<SettingsBloc>()),
      child: MaterialStyleRecentlyAddedView(refreshOnLoad: refreshOnLoad),
    );
  }
}

class MaterialStyleRecentlyAddedView extends StatefulWidget {
  final bool refreshOnLoad;

  const MaterialStyleRecentlyAddedView({
    super.key,
    required this.refreshOnLoad,
  });

  @override
  State<MaterialStyleRecentlyAddedView> createState() => _MaterialStyleRecentlyAddedViewState();
}

class _MaterialStyleRecentlyAddedViewState extends State<MaterialStyleRecentlyAddedView> {
  final _scrollController = ScrollController();
  late RecentlyAddedBloc _recentlyAddedBloc;
  late SettingsBloc _settingsBloc;
  late ServerModel _server;
  MediaType? _mediaType;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
    _recentlyAddedBloc = context.read<RecentlyAddedBloc>();
    _settingsBloc = context.read<SettingsBloc>();
    final settingsState = _settingsBloc.state as SettingsSuccess;

    _server = settingsState.appSettings.activeServer;

    _mediaType = settingsState.appSettings.recentlyAddedFilter == 'all'
        ? null
        : Cast.castStringToMediaType(
            settingsState.appSettings.recentlyAddedFilter,
          );

    _recentlyAddedBloc.add(
      RecentlyAddedFetched(
        server: _server,
        mediaType: _mediaType,
        freshFetch: widget.refreshOnLoad,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is SettingsSuccess) {
          _server = state.appSettings.activeServer;

          _recentlyAddedBloc.add(
            RecentlyAddedFetched(
              server: _server,
              mediaType: _mediaType,
            ),
          );
        }
      },
      child: MaterialStyleScaffoldWithInnerDrawer(
        title: const Text(LocaleKeys.recently_added_title).tr(),
        actions: _server.id != null ? _appBarActions() : [],
        body: BlocBuilder<RecentlyAddedBloc, RecentlyAddedState>(
          builder: (context, state) {
            return MaterialStylePageBody(
              loading: state.status == BlocStatus.initial && !state.hasReachedMax,
              child: MaterialStyleRefreshIndicator(
                onRefresh: () {
                  _recentlyAddedBloc.add(
                    RecentlyAddedFetched(
                      server: _server,
                      mediaType: _mediaType,
                      freshFetch: true,
                    ),
                  );

                  return Future.value(null);
                },
                child: Builder(
                  builder: (context) {
                    if (state.recentlyAdded.isEmpty) {
                      if (state.status == BlocStatus.failure) {
                        return MaterialStyleStatusPage(
                          scrollable: true,
                          message: state.message ?? '',
                          suggestion: state.suggestion ?? '',
                        );
                      }
                      if (state.status == BlocStatus.success) {
                        return MaterialStyleStatusPage(
                          scrollable: true,
                          message: LocaleKeys.recently_added_empty_message.tr(),
                        );
                      }
                    }

                    return ListView.separated(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      itemCount: state.hasReachedMax || state.status == BlocStatus.initial
                          ? state.recentlyAdded.length
                          : state.recentlyAdded.length + 1,
                      separatorBuilder: (context, index) => const Gap(8),
                      itemBuilder: (context, index) {
                        if (index >= state.recentlyAdded.length) {
                          return MaterialStyleBottomLoader(
                            status: state.status,
                            failure: state.failure,
                            message: state.message,
                            suggestion: state.suggestion,
                            onTap: () {
                              _recentlyAddedBloc.add(
                                RecentlyAddedFetched(
                                  server: _server,
                                  mediaType: _mediaType,
                                ),
                              );
                            },
                          );
                        }

                        final recentlyAdded = state.recentlyAdded[index];

                        return MaterialStyleRecentlyAddedCard(
                          server: _server,
                          recentlyAdded: recentlyAdded,
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _recentlyAddedBloc.add(
        RecentlyAddedFetched(
          server: _server,
          mediaType: _mediaType,
        ),
      );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  List<Widget> _appBarActions() {
    return [
      IconButton(
        tooltip: LocaleKeys.filter_recently_added_title.tr(),
        icon: FaIcon(
          FontAwesomeIcons.filter,
          size: 20,
          color: _mediaType != null ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
        ),
        onPressed: () async {
          final result = await showModalBottomSheet<({MediaType? mediaType})>(
            context: context,
            isScrollControlled: true,
            builder: (_) => MaterialStyleRecentlyAddedFilterBottomSheet(
              mediaType: _mediaType,
            ),
          );

          if (result != null && result.mediaType != _mediaType) {
            setState(() {
              _mediaType = result.mediaType;
            });

            _settingsBloc.add(
              SettingsUpdateRecentlyAddedFilter(Cast.castToString(_mediaType) ?? 'all'),
            );

            _recentlyAddedBloc.add(
              RecentlyAddedFetched(
                server: _server,
                mediaType: _mediaType,
                freshFetch: true,
              ),
            );
          }
        },
      ),
    ];
  }
}
