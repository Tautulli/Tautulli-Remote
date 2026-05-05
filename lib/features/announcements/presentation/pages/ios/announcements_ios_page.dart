import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/pages/ios/status_ios_page.dart';
import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/announcements_bloc.dart';
import '../../widgets/ios/announcement_ios_card.dart';

class AnnouncementsIosPage extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const AnnouncementsIosPage({
    super.key,
    this.showBackButton = false,
    this.previousPageTitle,
  });

  static const routeName = '/announcements';

  @override
  Widget build(BuildContext context) {
    return AnnouncementsIosView(
      showBackButton: showBackButton,
      previousPageTitle: previousPageTitle,
    );
  }
}

class AnnouncementsIosView extends StatefulWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const AnnouncementsIosView({
    super.key,
    required this.showBackButton,
    this.previousPageTitle,
  });

  @override
  State<AnnouncementsIosView> createState() => _AnnouncementsIosViewState();
}

class _AnnouncementsIosViewState extends State<AnnouncementsIosView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2)).then(
      (_) {
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
    return PageScaffoldCupertino(
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
                  return AnnouncementIosCard(
                    announcement: announcement,
                    lastReadAnnouncementId: state.lastReadAnnouncementId,
                  );
                },
              ),
            );
          }
          if (state is AnnouncementsFailure) {
            return StatusIosPage(message: state.message);
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
