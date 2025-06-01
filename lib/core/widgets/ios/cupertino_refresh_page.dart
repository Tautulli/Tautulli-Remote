import 'dart:async';

import 'package:flutter/cupertino.dart';

class CupertinoRefreshPage extends StatefulWidget {
  final Future Function()? onRefresh;
  final Widget sliver;

  const CupertinoRefreshPage({
    super.key,
    required this.onRefresh,
    required this.sliver,
  });

  @override
  State<CupertinoRefreshPage> createState() => _CupertinoRefreshPageState();
}

class _CupertinoRefreshPageState extends State<CupertinoRefreshPage> {
  /// Whether the scroll view is at the top.
  ///
  /// This is used to determine whether to show the refresh indicator.
  var _isAtTop = true;

  final _controller = ScrollController();

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
          if (_isAtTop)
            CupertinoSliverRefreshControl(
              onRefresh: widget.onRefresh,
            ),
          widget.sliver,
        ],
      ),
    );
  }
}
