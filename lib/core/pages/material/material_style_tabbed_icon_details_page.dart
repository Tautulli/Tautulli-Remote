import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../widgets/base/sensitive_text.dart';

const double _expandedHeight = 196;

class MaterialStyleTabbedIconDetailsPage extends StatefulWidget {
  final bool sensitive;
  final Widget? background;
  final Widget? icon;
  final String title;
  final Widget subtitle;
  final List<Widget> tabs;
  final List<Widget> tabChildren;

  const MaterialStyleTabbedIconDetailsPage({
    super.key,
    this.sensitive = false,
    this.background,
    this.icon,
    required this.title,
    required this.subtitle,
    required this.tabs,
    required this.tabChildren,
  });

  @override
  State<MaterialStyleTabbedIconDetailsPage> createState() => _SliverTabbedIconDetailsStatePage();
}

class _SliverTabbedIconDetailsStatePage extends State<MaterialStyleTabbedIconDetailsPage> {
  final ScrollController _scrollController = ScrollController();
  double titleOpacity = 0;
  double radius = 16;
  double detailsOpacity = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.tabs.length,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
        ),
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
                    opacity: titleOpacity,
                    child: Text(widget.title).sensitive(enabled: widget.sensitive),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: Column(
                      children: [
                        Expanded(
                          child: BlocBuilder<SettingsBloc, SettingsState>(
                            builder: (context, state) {
                              state as SettingsSuccess;

                              return Stack(
                                children: [
                                  Positioned.fill(
                                    child: !state.appSettings.disableImageBackgrounds
                                        ? widget.background ??
                                              DecoratedBox(
                                                position: DecorationPosition.foreground,
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withValues(alpha: 0.2),
                                                ),
                                              )
                                        : const SizedBox.shrink(),
                                  ),
                                  // Covers the thin line between top of TabBar and the background color
                                  Positioned(
                                    bottom: 0,
                                    child: Container(
                                      height: 5,
                                      width: MediaQuery.of(context).size.width,
                                      color: Theme.of(context).colorScheme.surface,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(radius),
                                        topRight: Radius.circular(radius),
                                      ),
                                      child: Container(
                                        height: 60,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.surface,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 8,
                                    bottom: 10,
                                    child: Opacity(
                                      opacity: detailsOpacity,
                                      child: widget.icon,
                                    ),
                                  ),
                                  Positioned(
                                    left: 96,
                                    bottom: 15,
                                    child: Opacity(
                                      opacity: detailsOpacity,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.title,
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ).sensitive(enabled: widget.sensitive),
                                          widget.subtitle,
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        Container(
                          height: 46,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ],
                    ),
                  ),
                  bottom: TabBar(
                    overlayColor: WidgetStateProperty.resolveWith(
                      (states) {
                        if (states.contains(WidgetState.pressed)) {
                          return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12);
                        }
                        return null;
                      },
                    ),
                    labelColor: Theme.of(context).colorScheme.onSurface,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                    tabs: widget.tabs,
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: widget.tabChildren.map(
              (tabSliver) {
                return MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: Builder(
                    key: PageStorageKey(ObjectKey(tabSliver)),
                    builder: (context) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: NestedScrollView.sliverOverlapAbsorberHandleFor(
                              context,
                            ).layoutExtent!,
                          ),
                          child: tabSliver,
                        ),
                      );
                    },
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }

  void _onScroll() {
    final double progress = _scrollController.offset / (_expandedHeight - 46 - kToolbarHeight);
    final double progressDelayed = (_scrollController.offset - 50) / (_expandedHeight - 50 - kToolbarHeight - 50);

    double newRadius = radius;
    double newDetailsOpacity = detailsOpacity;
    double newTitleOpacity = titleOpacity;

    // Using easeInSine calculation from https://easings.net/#easeInSine
    if (progress <= 1) {
      newRadius = (1 - (1 - cos((progress * pi) / 2))) * 16;
    }

    // Using easeInSine calculation from https://easings.net/#easeInSine
    if (progress <= 0) {
      newDetailsOpacity = 1;
    } else if (progress <= 1) {
      newDetailsOpacity = cos((progress * pi) / 2);
    } else {
      newDetailsOpacity = 0;
    }

    // Using easeInExpo calculation from https://easings.net/#easeInExpo
    if (progressDelayed <= 0) {
      newTitleOpacity = 0;
    } else if (progressDelayed <= 1) {
      newTitleOpacity = pow(2, 10 * progressDelayed - 10).toDouble();
    } else {
      newTitleOpacity = 1;
    }

    if (newRadius != radius || newDetailsOpacity != detailsOpacity || newTitleOpacity != titleOpacity) {
      setState(() {
        radius = newRadius;
        detailsOpacity = newDetailsOpacity;
        titleOpacity = newTitleOpacity;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}
