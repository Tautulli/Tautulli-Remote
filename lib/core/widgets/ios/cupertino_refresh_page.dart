import 'dart:async';

import 'package:flutter/cupertino.dart';

class CupertinoRefreshPage extends StatefulWidget {
  final Future Function()? onRefresh;
  final Widget? sliver;
  final List<Widget>? slivers;
  final ScrollController? scrollController;

  const CupertinoRefreshPage({
    super.key,
    required this.onRefresh,
    this.sliver,
    this.slivers,
    this.scrollController,
  }) : assert(
         (sliver != null && slivers == null) || (sliver == null && slivers != null),
         'Exactly one of sliver or slivers must be provided.',
       );

  @override
  State<CupertinoRefreshPage> createState() => _CupertinoRefreshPageState();
}

class _CupertinoRefreshPageState extends State<CupertinoRefreshPage> {
  /// Whether the scroll view is at the top.
  ///
  /// This is used to determine whether to show the refresh indicator.
  var _isAtTop = true;
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();

    if (widget.scrollController != null) {
      _controller = widget.scrollController!;
    } else {
      _controller = ScrollController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        /// Check if the scroll view is at the top.
        ///
        /// True when scroll offset <= 0. False otherwise.
        if (notification is ScrollStartNotification) {
          if (_controller.offset <= 0 && !_isAtTop) {
            scheduleMicrotask(() {
              if (mounted) {
                setState(() {
                  _isAtTop = true;
                });
              }
            });
          } else if (_controller.offset > 0 && _isAtTop) {
            scheduleMicrotask(() {
              if (mounted) {
                setState(() {
                  _isAtTop = false;
                });
              }
            });
          }
        }
        return false;
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _controller,
        slivers: [
          /// Show the refresh indicator only when the scroll view is at the top.
          if (_isAtTop && widget.onRefresh != null)
            CupertinoSliverRefreshControl(
              onRefresh: widget.onRefresh,
            ),
          ?widget.sliver,
          ...?widget.slivers,
        ],
      ),
    );
  }
}
