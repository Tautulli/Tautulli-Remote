import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

import '../../../core/widgets/ios/custom_cupertino_nav_bar.dart' as nav;
import '../../../translations/locale_keys.g.dart';
import '../../helpers/theme_helper.dart';

class TabbedIconDetailsIosPage extends StatefulWidget {
  final String? previousPageTitle;
  final bool sensitive;
  final Widget? background;
  final Widget? icon;
  final String title;
  final Widget subtitle;
  final Map<int, Widget> segments;
  final List<Widget> segmentChildren;

  const TabbedIconDetailsIosPage({
    super.key,
    this.previousPageTitle,
    this.sensitive = false,
    this.background,
    this.icon,
    required this.title,
    required this.subtitle,
    required this.segments,
    required this.segmentChildren,
  });

  @override
  State<TabbedIconDetailsIosPage> createState() => _TabbedIconDetailsIosPageState();
}

class _TabbedIconDetailsIosPageState extends State<TabbedIconDetailsIosPage> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final double topAreaHeight = MediaQuery.paddingOf(context).top + kMinInteractiveDimensionCupertino + 10;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.transparent,
      navigationBar: nav.CupertinoNavigationBar(
        padding: const EdgeInsetsDirectional.only(end: 16),
        enableBackgroundFilterBlur: false,
        backgroundColor: CupertinoColors.transparent,
        leading: CupertinoNavigationBarBackButton(
          previousPageTitle: widget.previousPageTitle,
          color: ThemeHelper.cupertinoNavigationBarItemColor(),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: Stack(
        children: [
          //* Background
          Column(
            children: [
              SizedBox(
                height: topAreaHeight + 35,
                width: double.infinity,
                child: ClipRect(
                  child: ColoredBox(
                    color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                    child: DecoratedBox(
                      position: DecorationPosition.foreground,
                      decoration: BoxDecoration(
                        color: CupertinoColors.black.withValues(alpha: 0.2),
                      ),
                      child: widget.background,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8 + 80 + 8, right: 8 + 80 + 8, top: 4),
                        //* User Info
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.sensitive ? LocaleKeys.hidden_message.tr() : widget.title,
                            ),
                            widget.subtitle,
                          ],
                        ),
                      ),
                      const Gap(12),
                      //* User Details
                      if (widget.segments.keys.length >= 2)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Center(
                            child: SizedBox(
                              width: double.infinity,
                              child: CupertinoSlidingSegmentedControl(
                                groupValue: _selectedIndex,
                                onValueChanged: _onSegmentChanged,
                                children: widget.segments,
                              ),
                            ),
                          ),
                        ),
                      if (widget.segments.keys.length >= 2) const Gap(8),
                      Expanded(
                        // Need to remove the top and bottom padding since PageView starts partway down the screen. The scrollbar was offsetting for the top and bottom areas by default.
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          removeBottom: true,
                          child: PageView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: _pageController,
                            children: widget.segmentChildren,
                          ),
                        ),
                      ),
                      // Leaves space for the tab bar and below
                      SizedBox(
                        height: MediaQuery.paddingOf(context).bottom,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          //* Icon
          Positioned(
            left: 8,
            top: topAreaHeight,
            child: widget.icon ?? const SizedBox(),
          ),
        ],
      ),
    );
  }

  void _onSegmentChanged(int? value) {
    if (value == null) return;

    setState(() {
      _selectedIndex = value;
    });

    _pageController.animateToPage(
      value,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
