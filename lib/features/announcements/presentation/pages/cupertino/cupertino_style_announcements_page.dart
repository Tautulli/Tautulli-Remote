import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/pages/cupertino/cupertino_style_status_page.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_page_scaffold.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/announcements_bloc.dart';
import '../../widgets/cupertino/cupertino_style_announcement_card.dart';

class CupertinoStyleAnnouncementsPage extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const CupertinoStyleAnnouncementsPage({
    super.key,
    this.showBackButton = false,
    this.previousPageTitle,
  });

  static const routeName = '/announcements';

  @override
  Widget build(BuildContext context) {
    return CupertinoStyleAnnouncementsView(
      showBackButton: showBackButton,
      previousPageTitle: previousPageTitle,
    );
  }
}

class CupertinoStyleAnnouncementsView extends StatefulWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const CupertinoStyleAnnouncementsView({
    super.key,
    required this.showBackButton,
    this.previousPageTitle,
  });

  @override
  State<CupertinoStyleAnnouncementsView> createState() => _CupertinoStyleAnnouncementsViewState();
}

class _CupertinoStyleAnnouncementsViewState extends State<CupertinoStyleAnnouncementsView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2)).then(
      (_) {
        if (!mounted) return;
        final announcementsBloc = context.read<AnnouncementsBloc>();

        if (announcementsBloc.state is AnnouncementsSuccess) {
          final currentState = announcementsBloc.state as AnnouncementsSuccess;
          if (currentState.unread) {
            context.read<AnnouncementsBloc>().add(
              AnnouncementsMarkRead(),
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return CupertinoStylePageScaffold(
      previousPageTitle: widget.previousPageTitle,
      middle: const Text(LocaleKeys.announcements_title).tr(),
      child: BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
        builder: (context, state) {
          if (state is AnnouncementsSuccess) {
            return CupertinoScrollbar(
              controller: _scrollController,
              child: ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.all(8),
                itemCount: state.filteredList.length,
                separatorBuilder: (context, index) => const Gap(8),
                itemBuilder: (context, index) {
                  final announcement = state.filteredList[index];
                  return CupertinoStyleAnnouncementCard(
                    announcement: announcement,
                    lastReadAnnouncementId: state.lastReadAnnouncementId,
                  );
                },
              ),
            );
          }
          if (state is AnnouncementsFailure) {
            return CupertinoStyleStatusPage(message: state.message);
          }

          return const Center(
            child: CupertinoActivityIndicator(),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
