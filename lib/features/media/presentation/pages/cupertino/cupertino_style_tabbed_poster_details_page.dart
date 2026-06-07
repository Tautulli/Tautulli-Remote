import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/override/cupertino/nav_bar_override.dart' as nav;
import '../../../../../core/widgets/cupertino/cupertino_style_poster.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';

class CupertinoStyleTabbedPosterDetailsPage extends StatefulWidget {
  final String? previousPageTitle;
  final bool sensitive;
  final Widget? background;
  final Widget? navBarActions;
  final CupertinoStylePoster? poster;
  final String? itemTitle;
  final String? itemSubtitle;
  final String? itemDetail;
  final Map<int, Widget> segments;
  final List<Widget> segmentChildren;

  const CupertinoStyleTabbedPosterDetailsPage({
    super.key,
    this.previousPageTitle,
    this.sensitive = false,
    this.background,
    this.navBarActions,
    this.poster,
    required this.itemTitle,
    this.itemSubtitle,
    this.itemDetail,
    required this.segments,
    required this.segmentChildren,
  });

  @override
  State<CupertinoStyleTabbedPosterDetailsPage> createState() => _CupertinoStyleTabbedPosterDetailsPageState();
}

class _CupertinoStyleTabbedPosterDetailsPageState extends State<CupertinoStyleTabbedPosterDetailsPage> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final double topAreaHeight = MediaQuery.paddingOf(context).top + kMinInteractiveDimensionCupertino + 10;

    return LayoutBuilder(
      builder: (context, constraints) {
        final tpItemTitle = TextPainter(
          text: TextSpan(text: widget.itemTitle ?? ''),
          maxLines: 1,
          textDirection: Directionality.of(context),
        );
        final tpItemSubtitle = TextPainter(
          text: TextSpan(text: widget.itemSubtitle ?? ''),
          maxLines: 1,
          textDirection: Directionality.of(context),
        );
        tpItemTitle.layout(maxWidth: constraints.maxWidth - 127);
        tpItemSubtitle.layout(maxWidth: constraints.maxWidth - 127);

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
            trailing: widget.navBarActions,
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  //* Background
                  BlocBuilder<SettingsBloc, SettingsState>(
                    builder: (context, state) {
                      state as SettingsSuccess;

                      return SizedBox(
                        height: topAreaHeight + 60,
                        width: double.infinity,
                        child: ClipRect(
                          child: ColoredBox(
                            color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                            child: DecoratedBox(
                              position: DecorationPosition.foreground,
                              decoration: BoxDecoration(
                                color: CupertinoColors.black.withValues(alpha: 0.2),
                              ),
                              child: !state.appSettings.disableImageBackgrounds ? widget.background : null,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 97,
                            padding: const EdgeInsets.only(left: 8 + 100 + 8, right: 8, top: 4),
                            //* Item Info
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.sensitive ? LocaleKeys.hidden_message.tr() : widget.itemTitle ?? '',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                  maxLines: tpItemTitle.didExceedMaxLines && tpItemSubtitle.didExceedMaxLines ? 1 : 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (widget.itemSubtitle != null)
                                  Text(
                                    widget.itemSubtitle!,
                                    maxLines: 2,
                                  ),
                                if (widget.itemDetail != null)
                                  Text(
                                    widget.itemDetail!,
                                    maxLines: tpItemTitle.didExceedMaxLines || tpItemSubtitle.didExceedMaxLines ? 1 : 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                          //* Item Details
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
              //* Poster
              Positioned(
                left: 8,
                top: topAreaHeight,
                child: SizedBox(
                  height: 150,
                  child: widget.poster,
                ),
              ),
            ],
          ),
        );
      },
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
