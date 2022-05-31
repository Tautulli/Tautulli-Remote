import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../translations/locale_keys.g.dart';

const double _expandedHeight = 196;

class SliverTabbedDetails extends StatefulWidget {
  final bool sensitive;
  final Widget? background;
  final Widget? icon;
  final String title;
  final Widget subtitle;
  final List<Widget> tabs;
  final List<Widget> tabChildren;

  const SliverTabbedDetails({
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
  State<SliverTabbedDetails> createState() => _SliverTabbedDetailsState();
}

class _SliverTabbedDetailsState extends State<SliverTabbedDetails> {
  final ScrollController _scrollController = ScrollController();
  double titleOpacity = 0;
  double radius = 16;
  double detailsOpacity = 1;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      double progress =
          (_scrollController.offset) / (_expandedHeight - 46 - kToolbarHeight);
      double progressDelayed = (_scrollController.offset - 50) /
          (_expandedHeight - 50 - kToolbarHeight - 50);

      // Using easeInSine calculation from https://easings.net/#easeInSine
      if (progress <= 1) {
        setState(() {
          radius = (1 - (1 - cos((progress * pi) / 2))) * 16;
        });
      }

      // Using easeInSine calculation from https://easings.net/#easeInSine
      if (progress <= 0 && detailsOpacity != 1) {
        setState(() {
          detailsOpacity = 1;
        });
      } else if (progress > 0 && progress <= 1) {
        setState(() {
          detailsOpacity = cos((progress * pi) / 2);
        });
      } else if (progress > 1 && detailsOpacity != 0) {
        setState(() {
          detailsOpacity = 0;
        });
      }

      // Using easeInExpo calculation from https://easings.net/#easeInExpo
      if (progressDelayed <= 0 && titleOpacity != 0) {
        setState(() {
          titleOpacity = 0;
        });
      } else if (progressDelayed > 0 && progressDelayed <= 1) {
        setState(() {
          titleOpacity = pow(2, 10 * progressDelayed - 10).toDouble();
        });
      } else if (progressDelayed > 1 && titleOpacity != 1) {
        setState(() {
          titleOpacity = 1;
        });
      }
    });
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
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  pinned: true,
                  expandedHeight: _expandedHeight,
                  title: Opacity(
                    opacity: titleOpacity,
                    child: Text(
                      widget.sensitive
                          ? LocaleKeys.hidden_message.tr()
                          : widget.title,
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: Column(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: DecoratedBox(
                                  position: DecorationPosition.foreground,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                  child: widget.background,
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.sensitive
                                            ? LocaleKeys.hidden_message.tr()
                                            : widget.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      widget.subtitle,
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 46,
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ],
                    ),
                  ),
                  bottom: TabBar(
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
                          color: Theme.of(context).colorScheme.background,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
