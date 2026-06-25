import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../types/media_type.dart';
import '../../types/playback_state.dart';
import '../base/image_gradient_background.dart';
import '../../../features/settings/data/models/custom_header_model.dart';
import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import 'material_style_poster.dart';

const double _expandedHeight = 220;

class MaterialStylePosterDetailsPage extends StatefulWidget {
  final String itemTitle;
  final String? itemSubtitle;
  final String? itemDetail;
  final Uri? posterUri;
  final MediaType? mediaType;
  final PlaybackState? activityState;
  final List<Widget> appBarActions;
  final Widget body;
  final double bodyTopPadding;

  const MaterialStylePosterDetailsPage({
    super.key,
    required this.itemTitle,
    this.itemSubtitle,
    this.itemDetail,
    this.posterUri,
    this.mediaType,
    this.activityState,
    required this.appBarActions,
    required this.body,
    this.bodyTopPadding = 8,
  });

  @override
  State<MaterialStylePosterDetailsPage> createState() => _MaterialStylePosterDetailsPageState();
}

class _MaterialStylePosterDetailsPageState extends State<MaterialStylePosterDetailsPage> {
  final ScrollController _scrollController = ScrollController();
  double _titleOpacity = 0;
  double _radius = 16;
  double _detailsOpacity = 1;
  double _backgroundCoverOpacity = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  pinned: true,
                  expandedHeight: _expandedHeight,
                  title: Opacity(
                    opacity: _titleOpacity,
                    child: Text(widget.itemSubtitle ?? widget.itemTitle),
                  ),
                  actions: widget.appBarActions,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: BlocBuilder<SettingsBloc, SettingsState>(
                      builder: (context, settingsState) {
                        settingsState as SettingsSuccess;

                        return Stack(
                          children: [
                            // Background image
                            Positioned.fill(
                              child: !settingsState.appSettings.disableImageBackgrounds
                                  ? ImageGradientBackground(
                                      imageUri: widget.posterUri,
                                      httpHeaders: {
                                        for (CustomHeaderModel headerModel
                                            in settingsState.appSettings.activeServer.customHeaders)
                                          headerModel.key: headerModel.value,
                                      },
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            // Fades the info section as the page is scrolled
                            Positioned.fill(
                              child: ColoredBox(
                                color: Theme.of(context).colorScheme.surface.withValues(alpha: _backgroundCoverOpacity),
                              ),
                            ),
                            // The area behind the info and in front of the background
                            Positioned(
                              bottom: 0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(_radius),
                                  topRight: Radius.circular(_radius),
                                ),
                                child: Container(
                                  height: 100,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surface,
                                  ),
                                ),
                              ),
                            ),
                            // Poster
                            Positioned(
                              left: 8,
                              bottom: 10,
                              child: Opacity(
                                opacity: _detailsOpacity,
                                child: SizedBox(
                                  height: 150,
                                  child: MaterialStylePoster(
                                    mediaType: widget.mediaType,
                                    uri: widget.posterUri,
                                    activityState: widget.activityState,
                                    opaqueBackground: true,
                                  ),
                                ),
                              ),
                            ),
                            // Title, subtitle, detail text
                            Positioned.fill(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      top: constraints.maxHeight - 97,
                                      left: 116,
                                      right: 8,
                                    ),
                                    child: Opacity(
                                      opacity: _detailsOpacity,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.itemTitle,
                                            style: const TextStyle(fontSize: 18),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if (widget.itemSubtitle != null)
                                            Text(
                                              widget.itemSubtitle!,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          if (widget.itemDetail != null)
                                            Text(
                                              widget.itemDetail!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Builder(
            builder: (context) {
              return MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
                  child: CustomScrollView(
                    slivers: [
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.only(top: widget.bodyTopPadding),
                        sliver: SliverToBoxAdapter(
                          child: widget.body,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onScroll() {
    final double progress = _scrollController.offset / (_expandedHeight - kToolbarHeight);
    final double progressDelayed = (_scrollController.offset - 50) / (_expandedHeight - 50 - kToolbarHeight - 50);

    final double newRadius = progress <= 1 ? pow(1 - progress, 3).toDouble() * 16 : 0;

    final double newDetailsOpacity;
    if (progress <= 0) {
      newDetailsOpacity = 1;
    } else if (progress <= 1) {
      newDetailsOpacity = pow(1 - progress, 3).toDouble();
    } else {
      newDetailsOpacity = 0;
    }

    final double newBackgroundCoverOpacity;
    if (progress <= 0) {
      newBackgroundCoverOpacity = 0;
    } else if (progress <= 1) {
      newBackgroundCoverOpacity = sin((progress * pi) / 2);
    } else {
      newBackgroundCoverOpacity = 1;
    }

    final double newTitleOpacity;
    if (progressDelayed <= 0) {
      newTitleOpacity = 0;
    } else if (progressDelayed <= 1) {
      newTitleOpacity = progressDelayed * progressDelayed;
    } else {
      newTitleOpacity = 1;
    }

    if (newRadius == _radius &&
        newDetailsOpacity == _detailsOpacity &&
        newBackgroundCoverOpacity == _backgroundCoverOpacity &&
        newTitleOpacity == _titleOpacity) {
      return;
    }

    setState(() {
      _radius = newRadius;
      _detailsOpacity = newDetailsOpacity;
      _backgroundCoverOpacity = newBackgroundCoverOpacity;
      _titleOpacity = newTitleOpacity;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}
